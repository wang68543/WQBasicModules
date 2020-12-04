//
//  ModalPresentationContext.swift
//  Pods
//
//  Created by WQ on 2020/8/21.
//

import UIKit
//https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html
@available(iOS 10.0, *)
open class ModalPresentationContext: ModalContext {
    private var intercatController: UIPercentDrivenInteractiveTransition?
     
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        guard !controller.isBeingPresented else { return }
        super.show(controller, statesConfig: statesConfig, completion: completion)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        switch statesConfig.showStyle {
        case .alert, .actionSheet:
            self.animator.duration = 0.45
        default:
            break
        }
        self.config.fromViewController?.present(controller, animated: self.animator.areAnimationEnable, completion: completion)
    }
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        super.hide(controller, animated: flag, completion: completion)
        switch styleConfig.showStyle {
        case .alert, .actionSheet:
            self.animator.duration = 0.25
        default:
            break
        }
        // 交给系统dismiss
        return false
    }
    
    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        super.interactive(present: controller, statesConfig: states)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        switch states.showStyle {
        case .alert, .actionSheet:
            self.animator.duration = 0.45
        default:
            break
        }
        controller.view.isUserInteractionEnabled = false
        self.config.fromViewController?.present(controller, animated: true, completion: nil)
    }
    
    public override func interactive(dismiss controller: WQLayoutController) {
        super.interactive(dismiss: controller)
        intercatController = UIPercentDrivenInteractiveTransition()
        controller.dismiss(animated: true, completion: nil)
    }
    public override func interactive(update controller: WQLayoutController, progress: CGFloat, isDismiss: Bool) {
        super.interactive(update: controller, progress: progress, isDismiss: isDismiss)
        self.intercatController?.update(progress)
    }
    public override func interactive(finish controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        super.interactive(finish: controller, velocity: velocity, isDismiss: isDismiss)
        let provider = UISpringTimingParameters.completion(velocity)
        self.intercatController?.timingCurve = provider
        self.intercatController?.finish()
        if !isDismiss {
            controller.view.isUserInteractionEnabled = true
        }
//        self.intercatController = nil
    }
    public override func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        super.interactive(cancel: controller, velocity: velocity, isDismiss: isDismiss)
        let provider = UISpringTimingParameters.completion(velocity)
        self.intercatController?.timingCurve = provider
        self.intercatController?.cancel()
//        self.intercatController = nil
    }
    
}
@available(iOS 10.0, *)
extension ModalPresentationContext: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

      
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.intercatController : nil
    } 
}
@available(iOS 10.0, *)
extension ModalPresentationContext: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animator.duration
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        let vcFinalFrame = transitionContext.finalFrame(for: toVC)
        let isPresented = toVC.presentingViewController === fromVC
        func completionBlock() {
            let success = !transitionContext.transitionWasCancelled
            if (isPresented && !success) {
                toVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
        let toVCView = transitionContext.view(forKey: .to)
        let transitionView = transitionContext.containerView
        
        if let toView = toVCView {
            if transitionView !== toView {//解决 多次动画 而把自己放在栈顶的问题
               transitionView.addSubview(toView)
            }
        }
        
        if isPresented {
            toVCView?.frame = vcFinalFrame
            if let showViewController = toVC as? WQLayoutController {
                self.animator.preprocessor(.show, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            } 
        } else {
            if let showViewController = fromVC as? WQLayoutController {
                self.animator.preprocessor(.hide, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            }
        }
        
    }
}
