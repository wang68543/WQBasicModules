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
    func hide(_ controller: WQLayoutController, animated flag: Bool, completion: ModalAnimation.Completion?) -> Bool
    
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
    
    // viewWillAppear viewWillDisappear viewDidDisappear
    public var lifeCycleable: Bool = false 
    public var context: ModalContext?
    
    public let config: ModalConfig 
    ///背景View
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
            if gesture.direction.isHorizontal {
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
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.addGesture()
    }
    
    private func addGesture() {
        switch self.config.interactionDismiss {
        case .tapAll:
            self.view.addGestureRecognizer(tapGesture)
        case .tapOutSide:
            tapGesture.delegate = self
            self.view.addGestureRecognizer(tapGesture)
        case let .pan(direction):
            panGesture.direction = direction
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
        states.setupStates(self, config: self.config)
        context = ModalContext.modalContext(self.config, states: states)
        context?.show(self, statesConfig: states, completion: comletion)
    }
    
    public func startInteractive(_ states: StyleConfig) { 
        states.setupStates(self, config: self.config)
        context = ModalContext.modalContext(self.config, states: states)
        context?.interactive(present: self, statesConfig: states)
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        guard context?.hide(self, animated: flag, completion: completion) == false else {
            return
        }
        guard !self.isBeingDismissed else { return }
        super.dismiss(animated: flag, completion: completion)
    }
    
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
    
//    deinit {
////        #if WDEBUG
//        debugPrint("\(self):" + #function + "♻️")
////        #endif
//    } 
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