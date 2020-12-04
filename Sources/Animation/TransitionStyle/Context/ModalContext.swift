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
    
    public var isInteractive: Bool = false
    
    public init(_ config: ModalConfig, states: StyleConfig) {
        self.config = config
        self.styleConfig = states
        animator = states.animator
        super.init()
    }
    public func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        self.styleConfig = statesConfig
    }
    @discardableResult
    public func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        self.animator.areAnimationEnable = flag
        return true
    }
    
    
    public func interactive(dismiss controller: WQLayoutController) {
        self.isInteractive = true
    }
    
    public func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        self.isInteractive = true
        self.styleConfig = states
    }
    public func interactive(update controller: WQLayoutController, progress: CGFloat, isDismiss: Bool) {
    }
    
    public func interactive(finish controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        self.isInteractive = false
    }
    public func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        self.isInteractive = false
    }
    deinit {
       debugPrint("\(self):" + #function + "♻️")
    }
}

/// 主要用于驱动动画 含驱动管理
@available(iOS 10.0, *)
open class ModalDrivenContext: ModalContext {
    
    var interactiveAnimator: UIViewPropertyAnimator?
    
    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        super.interactive(present: controller, statesConfig: states)
        
        // 初始化 显示状态
        let areAnimationsEnabled =  UIView.areAnimationsEnabled
        UIView.setAnimationsEnabled(false)
        if let views = states.snapShotAttachAnimatorViews[.willShow] {
            views.forEach { view, subViews in
                subViews.forEach { view.addSubview($0) }
            }
        }
        states.states[.willShow]?.setup(for: .willShow)
        controller.container.layoutIfNeeded()
        controller.view.layoutIfNeeded()
        UIView.setAnimationsEnabled(areAnimationsEnabled)
     
    }
    public override func interactive(update controller: WQLayoutController, progress: CGFloat, isDismiss: Bool) {
        super.interactive(update: controller, progress: progress, isDismiss: isDismiss)
        guard let animator = self.interactiveAnimator else { return }
        guard !animator.isRunning else { return }
        animator.fractionComplete = progress
        
    }
    public override func interactive(dismiss controller: WQLayoutController) {
        super.interactive(dismiss: controller)
        interactiveAnimator = UIViewPropertyAnimator(duration: self.animator.duration, curve: .easeOut, animations: { [weak self] in
            guard let `self` = self else { return }
            self.styleConfig.states[.hide]?.setup(for: .hide)
        })
        
    }
    public override func interactive(finish controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        super.interactive(finish: controller, velocity: velocity, isDismiss: isDismiss)
        interactiveAnimator?.addCompletion({[weak self] position in
            guard let `self` = self else { return }
            if isDismiss {
                if position == .end {
                   self.hide(controller, animated: false, completion: nil)
                }
            } else {
                controller.view.isUserInteractionEnabled = true
            }
            
            self.interactiveAnimator = nil
        })
        
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactiveAnimator?.continueAnimation(withTimingParameters: provider, durationFactor: 1.0)
    }
    public override func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        interactiveAnimator?.addCompletion({[weak self] position in
            guard let `self` = self else { return }
            if isDismiss {
                if position == .start {
                    debugPrint("========")
                }
            }   
            self.interactiveAnimator = nil
        })
        super.interactive(cancel: controller, velocity: velocity, isDismiss: isDismiss)
        self.interactiveAnimator?.isReversed = true
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactiveAnimator?.continueAnimation(withTimingParameters: provider, durationFactor: 1.0)
        
    }
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
        case .modalPresentWithNavRoot:
            return ModalPresentWithNavRootContext(config, states: states)
        default:
            return nil
        }
    }
}
