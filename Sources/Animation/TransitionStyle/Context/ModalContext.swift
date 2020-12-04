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
    public func update(interactive controller: WQLayoutController, progress: CGFloat, isDismiss: Bool) {
    }
    public func began(interactive controller: WQLayoutController, isDismiss: Bool) {
        self.isInteractive = true
    }
    public func end(interactive controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        self.isInteractive = false
    }
    public func cancel(interactive controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) { 
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
    
    public override func update(interactive controller: WQLayoutController, progress: CGFloat, isDismiss: Bool) {
        super.update(interactive: controller, progress: progress, isDismiss: isDismiss)
        guard let animator = self.interactiveAnimator else { return }
        guard !animator.isRunning else { return }
        animator.fractionComplete = progress
        
    }
    public override func began(interactive controller: WQLayoutController, isDismiss: Bool) {
        super.began(interactive: controller, isDismiss: isDismiss)
        if isDismiss {
            interactiveAnimator = UIViewPropertyAnimator(duration: self.animator.duration, curve: .easeOut, animations: { [weak self] in
                guard let `self` = self else { return }
                self.styleConfig.states[.hide]?.setup(for: .hide)
            })
        }
        
    }
    public override func end(interactive controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        super.end(interactive: controller, velocity: velocity, isDismiss: isDismiss)
        interactiveAnimator?.addCompletion({[weak self] position in
            guard let `self` = self else { return }
            if position == .end {
               self.hide(controller, animated: false, completion: nil)
            }
            self.interactiveAnimator = nil
        })
        
        let velocityVector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
        let springParameters = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: velocityVector)
        self.interactiveAnimator?.continueAnimation(withTimingParameters: springParameters, durationFactor: 1.0)
    }
    public override func cancel(interactive controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        super.cancel(interactive: controller, velocity: velocity, isDismiss: isDismiss)
        interactiveAnimator?.addCompletion({[weak self] position in
            guard let `self` = self else { return }
            if position == .start {
                debugPrint("========")
            }
            self.interactiveAnimator = nil
        })
        self.interactiveAnimator?.isReversed = true
        let velocityVector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
        let springParameters = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: velocityVector)
        self.interactiveAnimator?.continueAnimation(withTimingParameters: springParameters, durationFactor: 1.0)
        
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
