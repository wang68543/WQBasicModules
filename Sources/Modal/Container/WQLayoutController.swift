//
//  WQLayoutContainerViewController.swift
//  Pods
//
//  Created by WQ on 2020/8/21.
//

import UIKit 
/**
 将当前控制器的View 作为transitionView 
 */
@available(iOS 10.0, *)
public protocol WQLayoutControllerTransition: NSObjectProtocol {
    func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: ModalAnimation.Completion?)
    // -> Bool
    func hide(_ controller: WQLayoutController, animated flag: Bool, completion: ModalAnimation.Completion?)
    
    // interactive
    func interactive(dismiss controller: WQLayoutController)
    func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig)
     
    func interactive(update progress: CGFloat) 
    func interactive(finish velocity: CGPoint)
    func interactive(cancel velocity: CGPoint)
} 
@available(iOS 10.0, *)
public class WQLayoutController: UIViewController {
    public internal(set) var isMovingToWindow: Bool = false
    public internal(set) var isMovingFromWindow: Bool = false
    
    public internal(set) var isPushing: Bool = false
    public internal(set) var isPoping: Bool = false
    /// 是否是按照顺序显示+-
    internal private(set) var isSequSequenceShow: Bool = false
    
    private var shouldEventManagement: Bool = false
    // viewWillAppear viewWillDisappear viewDidDisappear
    public var lifeCycleable: Bool = false 
    public var context: ModalContext?
    
    public let config: ModalConfig 
    ///背景View 主要用于假透明背景
    public weak var backgroundView: UIView?
    
    public init(_ config: ModalConfig, subView: UIView) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        self.setupBackgroudView()
        setup()
        self.container.addSubview(subView)
    }
    
    internal func setup() { 
        self.view.addSubview(dimmingView)
        self.view.addSubview(self.container)
    }
    func setupBackgroudView() {
        func addSnapshotView() {
            if let snapshotView = config.style.snapshotTransitaion {
                self.view.addSubview(snapshotView)
                self.view.sendSubviewToBack(snapshotView)
                self.backgroundView = snapshotView
            }
        }
        // 制作假透明场景
        if config.isShowWithNavigationController {
            addSnapshotView()
        }
        else {
            switch self.config.style {
            case .modalNavigation:
                addSnapshotView()
            default:
                break
            }
        }
    }
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        return gesture
    }()
    
    lazy var panGesture: PanDirectionGestureRecongnizer = {
        let gesture = PanDirectionGestureRecongnizer(target: self, action: #selector(panGestureAction(_:)))
        return gesture
    }()
    
    @objc func tapGestureAction(_ gseture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureAction(_ gesture: PanDirectionGestureRecongnizer) {
        switch gesture.state {
        case .began:
            gesture.setTranslation(.zero, in: gesture.view)
            self.context?.interactive(dismiss: self)
        break
        case .changed:
            self.context?.interactive(update: gesture.progress)
        case .ended:
            let velocity = gesture.velocity(in: gesture.view)
            let fast: Bool
            if gesture.lockDirection.isHorizontal {
                fast = abs(velocity.x) > 200
            } else {
                fast = abs(velocity.y) > 200
            }
            if gesture.progress > 0.5 || fast {
                self.context?.interactive(finish: velocity)
            } else {
                self.context?.interactive(cancel: velocity)
            }
        case .failed, .cancelled:
            let velocity = gesture.velocity(in: gesture.view)
            self.context?.interactive(cancel: velocity)
        default:
            break
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.shouldEventManagement {
            self.config.fromViewController?.beginAppearanceTransition(false, animated: animated)
        }
        self.container.viewWillAppear(animated)
        debugPrint(#function)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.shouldEventManagement {
            self.config.fromViewController?.endAppearanceTransition()
        }
        self.container.viewDidAppear(animated)
        debugPrint(#function)
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.shouldEventManagement {
            self.config.fromViewController?.beginAppearanceTransition(true, animated: animated)
        }
        self.container.viewWillDisappear(animated)
        debugPrint(#function)
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.shouldEventManagement {
            self.config.fromViewController?.endAppearanceTransition()
        }
        self.container.viewDidDisappear(animated)
        debugPrint(#function)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.addGesture()
        self.addKeyboardObserver()
    }
    
    
    private func addGesture() {
        switch self.config.interactionDismiss {
        case .tapAll:
            self.view.addGestureRecognizer(tapGesture)
        case .tapOutSide:
            tapGesture.delegate = self
            self.view.addGestureRecognizer(tapGesture)
        case let .pan(direction):
            panGesture.lockDirection = direction
            self.container.addGestureRecognizer(panGesture)
            break
        default:
            break
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundView?.frame = self.view.bounds
        dimmingView.frame = self.view.bounds  
    }
    public func modal(_ states: StyleConfig, comletion: ModalAnimation.Completion? = nil) { 
        context = ModalContext.modalContext(self.config, states: states)
        self.shouldEventManagement = self.config.controllerEventManagement
        if !self.config.isSequenceModal {
            ctxShow(states, comletion: comletion)
        } else {
            self.isSequSequenceShow = self.config.isSequenceModal
            FILOModalQueue.shared.modal(self, states: states, comletion: comletion)
        }
    }
    
    internal func ctxShow(_ states: StyleConfig, comletion: ModalAnimation.Completion?) {
        context?.show(self, statesConfig: states, completion: comletion)
    }
    internal func ctxHide(animated flag: Bool, completion: (() -> Void)?) {
        context?.hide(self, animated: flag, completion: completion)
//        guard context?.hide(self, animated: flag, completion: completion) == false else {
//            return
//        }
//        guard !self.isBeingDismissed else { return }
//        if !flag {
//            UIView.performWithoutAnimation {
//                super.dismiss(animated: flag, completion: completion)
//            }
//        } else {
//            super.dismiss(animated: flag, completion: completion)
//        }
    }
    
    public func startInteractive(_ states: StyleConfig) {
        context = ModalContext.modalContext(self.config, states: states)
        context?.interactive(present: self, statesConfig: states)
    }
    
    public func hidden(animated flag: Bool, completion: (() -> Void)? = nil) {
        if self.isSequSequenceShow {
            FILOModalQueue.shared.dismiss(self, flag: flag, completion: completion)
        } else {
            ctxHide(animated: flag, completion: completion)
        }
    }
//    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
//        if self.isSequSequenceShow {
//            FILOModalQueue.shared.dismiss(self, flag: flag, completion: completion)
//        } else {
//            ctxHide(animated: flag, completion: completion)
//        }
//    }
    
    // MARK: -- -UI属性
    internal lazy var dimmingView: UIView = {
       let diming = UIView()
        diming.isUserInteractionEnabled = false
        diming.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        diming.alpha = 0.0
        return diming
    }()
    
    /// 转场容器View
    public lazy var container: WQContainerView = {
       let transitionView = WQContainerView()
        transitionView.backgroundColor = UIColor.clear
        return transitionView
    }()
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeKeyboardObserver()
//        #if WDEBUG
        debugPrint("\(self):" + #function + "♻️")
//        #endif
    }
}
// MARK: - --Keyboard KVO
@available(iOS 10.0, *)
extension WQLayoutController {
    /// 添加键盘通知
    func addKeyboardObserver() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(adjustForKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(_ note: Notification) {
        guard let userInfo = note.userInfo,
              let keyboardValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        guard note.name == UIResponder.keyboardWillChangeFrameNotification else {
            self.container.transform = .identity
            return
        }
        var keyboardEndFrame = view.convert(keyboardValue, from: view.window)
        keyboardEndFrame.origin.y = keyboardEndFrame.origin.y - self.config.adjustOffsetDistanceKeyboard
        
        let intersection = self.container.frame.intersection(keyboardEndFrame)
        guard !intersection.isNull else {
            self.container.transform = .identity
            return
        }
        let transform = CGAffineTransform(translationX: .zero, y: -intersection.height)
        self.container.transform = transform
    }
    
}
@available(iOS 10.0, *)
extension WQLayoutController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.tapGesture,
           let tap = gestureRecognizer as? UITapGestureRecognizer {
            let point = tap.location(in: self.view)
            return !self.container.frame.contains(point)
        } else if gestureRecognizer === self.panGesture,
          let pan = gestureRecognizer as? PanDirectionGestureRecongnizer {
           let velocity = pan.velocity(in: self.view)
            return pan.canShouldBegin(velocity)
        } else {
            return true
        }
       
    }
} 
