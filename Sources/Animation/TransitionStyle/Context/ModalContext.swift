//
//  ModalContext.swift
//  Pods
//
//  Created by WQ on 2020/8/21.
//
import UIKit 
@available(iOS 10.0, *)
open class ModalContext: NSObject, WQLayoutControllerTransition {
    
    public let animator: ModalAnimation
    
    public unowned let config: ModalConfig
    
    public private(set) var styleConfig: StyleConfig
    
    /// 当前是否正在交互
    public private(set) var isInteractive: Bool = false
    
    /// 当前是否正在弹窗
    internal private(set) var isModal: Bool = false
    
    /// 用于记录当前
    internal weak var navgationController: UINavigationController?
    
    public init(_ config: ModalConfig, states: StyleConfig) {
        self.config = config
        self.styleConfig = states
        animator = states.animator
        super.init()
    }
    
    var animateDuration: TimeInterval {
        guard self.animator.duration == .zero else {
            return self.animator.duration
        }
        if self.isModal {
            if self.styleConfig.states.has(key: .didShow) {
                return 0.45
            } else {
                return 0.25
            }
        } else {
            return 0.25 
        }
    }
    public func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        self.isModal = true
        self.styleConfig = statesConfig
        self.animator.duration = self.animateDuration
    }
    @discardableResult
    public func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        self.isModal = false
        self.animator.areAnimationEnable = flag
        self.animator.duration = self.animateDuration
        return true
    }
    
    
    public func interactive(dismiss controller: WQLayoutController) {
        self.isInteractive = true
        self.isModal = false
        self.animator.duration = self.animateDuration
    }
    
    public func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        self.isInteractive = true
        self.isModal = true
        self.styleConfig = states
        self.animator.duration = self.animateDuration
    }
    public func interactive(update controller: WQLayoutController, progress: CGFloat, isModal: Bool) {
    }
    
    public func interactive(finish controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
        self.isInteractive = false
    }
    public func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
        self.isInteractive = false
    }
    deinit {
       debugPrint("\(self):" + #function + "♻️")
    }
}

@available(iOS 10.0, *)
public extension ModalContext {
    func navgationController(_ controller: WQLayoutController) -> UINavigationController { 
        guard self.navgationController == nil else {
            return self.navgationController!
        }
        let nav = self.config.navgationControllerType.init(rootViewController: controller)
        nav.setNavigationBarHidden(true, animated: false)
        self.navgationController = nav
        return nav
    }
    
    func viewController(_ controller: WQLayoutController) -> UIViewController {
        if self.config.isShowWithNavigationController {
           return self.navgationController(controller)
        } else {
            return controller
        }
    }
}

/// 主要用于驱动动画 含驱动管理
@available(iOS 10.0, *)
open class ModalDrivenContext: ModalContext {
    
    var interactiveAnimator: UIViewPropertyAnimator?
    
//    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
//        super.interactive(present: controller, statesConfig: states)
//        // 初始化 显示状态
//        let areAnimationsEnabled =  UIView.areAnimationsEnabled
//        UIView.setAnimationsEnabled(false)
//        if let views = states.snapShotAttachAnimatorViews[.willShow] {
//            views.forEach { view, subViews in
//                subViews.forEach { view.addSubview($0) }
//            }
//        }
//        states.states[.willShow]?.setup(for: .willShow)
//        controller.container.layoutIfNeeded()
//        controller.view.layoutIfNeeded()
//        UIView.setAnimationsEnabled(areAnimationsEnabled)
//        //TODO: - 待实现 驱动动画过程
//    }
    public override func interactive(update controller: WQLayoutController, progress: CGFloat, isModal: Bool) {
        super.interactive(update: controller, progress: progress, isModal: isModal)
        guard let animator = self.interactiveAnimator else { return }
        guard !animator.isRunning else { return }
        animator.fractionComplete = progress
    }
    
    func continueAnimation(_ velocity: CGPoint) {
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactiveAnimator?.continueAnimation(withTimingParameters: provider, durationFactor: 1.0)
    }
//    public override func interactive(dismiss controller: WQLayoutController) {
//        super.interactive(dismiss: controller)
//        if interactiveAnimator?.isRunning == true {
//            interactiveAnimator?.stopAnimation(true)
//        }
//        interactiveAnimator = UIViewPropertyAnimator(duration: self.animator.duration, curve: .easeOut, animations: { [weak self] in
//            guard let `self` = self else { return }
//            self.styleConfig.states[.hide]?.setup(for: .hide)
//        })
//    }
//    
//    func interactiveAnimateCompletion(_ controller: WQLayoutController, at position: UIViewAnimatingPosition, dismiss: Bool){
//        if dismiss {
//            if position == .end {
//               self.hide(controller, animated: false, completion: nil)
//            }
//        } else {
//            controller.view.isUserInteractionEnabled = true
//        }
//    }
//    public override func interactive(finish controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
//        super.interactive(finish: controller, velocity: velocity, isModal: isDismiss)
//        
//        interactiveAnimator?.addCompletion({[weak self] position in
//            guard let `self` = self else { return }
//            self.interactiveAnimateCompletion(controller, at: position, dismiss: isDismiss)
//            self.interactiveAnimator = nil
//        })
//        
//        let provider = UISpringTimingParameters.completion(velocity)
//        self.interactiveAnimator?.continueAnimation(withTimingParameters: provider, durationFactor: 1.0)
//    }
//    public override func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
//        interactiveAnimator?.addCompletion({[weak self] position in
//            guard let `self` = self else { return }
//            if isDismiss {
//                if position == .start {
//                    debugPrint("========")
//                }
//            }   
//            self.interactiveAnimator = nil
//        })
//        super.interactive(cancel: controller, velocity: velocity, isModal: isDismiss)
//        self.interactiveAnimator?.isReversed = true
//        let provider = UISpringTimingParameters.completion(velocity)
//        self.interactiveAnimator?.continueAnimation(withTimingParameters: provider, durationFactor: 1.0)
//        
//    }
}
@available(iOS 10.0, *)
extension UISpringTimingParameters {
    static func completion(_ velocity: CGPoint) -> UITimingCurveProvider {
        let velocityVector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
        return UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: velocityVector)
    }
}
 
/// 构造不同的动画场景
@available(iOS 10.0, *)
public extension ModalContext {
    static func modalContext(_ config: ModalConfig, states: StyleConfig) -> ModalContext? {
        let fixStyle: ModalPresentation
        if config.style == .autoModal {
            fixStyle = config.style.autoAdaptationStyle
        } else {
            fixStyle = config.style
        }
        switch fixStyle {
        case .modalSystem:
            return ModalPresentationContext(config, states: states)
        case .modalInParent:
            return ModalInParentContext(config, states: states)
        case .modalInWindow:
            return ModalInWindowContext(config, states: states)
        case .modalNavigation:
            return ModalNavigationContext(config, states: states) 
        default:
            return nil
        }
    }
}
