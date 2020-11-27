//
//  WQLayoutContainerViewController.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit 
/**
 将当前控制器的View 作为transitionView 
 */
public protocol WQLayoutControllerTransition: NSObjectProtocol {
//    func didViewLoad(_ controller: WQLayoutController)
    func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: ModalAnimation.Completion?)
    func hide(_ controller: WQLayoutController, animated flag: Bool, completion: ModalAnimation.Completion?) -> Bool
//    optional func update(_ controller: WQLayoutController, progress: CGFloat) 
}

public class WQLayoutController: UIViewController {
    // viewWillAppear viewWillDisappear viewDidDisappear
    public var lifeCycleable: Bool = false 
    public var context: ModalContext?
    
    public let config: ModalConfig
    public var statesConfig: StyleConfig?
    
    public init(_ config: ModalConfig, subView: UIView) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        setup()
        self.container.addSubview(subView)
    }
    
    internal func setup() { 
        self.view.addSubview(dimmingView)
        self.view.addSubview(self.container)
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
        let translate = gesture.translation(in: self.view)
        let offset = gesture.direction.translationOffset(with: translate)
        debugPrint(offset)
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
            self.view.addGestureRecognizer(panGesture)
            break
        default:
            break
        }
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dimmingView.frame = self.view.bounds
    }
    public func modal(_ states: StyleConfig, comletion: ModalAnimation.Completion? = nil) {
        statesConfig = states
        states.setupStates(self, config: self.config)
        context = ModalContext.modalContext(self.config, states: states)
        context?.show(self, statesConfig: states, completion: comletion)
    }
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let ctx = context {
            if ctx.hide(self, animated: flag, completion: completion) == false {
                super.dismiss(animated: flag, completion: completion)
            }
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
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
    
    deinit {
//        #if WDEBUG
        debugPrint("\(self):" + #function + "♻️")
//        #endif
    } 
}
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
