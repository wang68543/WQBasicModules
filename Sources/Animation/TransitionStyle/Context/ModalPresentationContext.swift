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
    private var interactController: UIPercentDrivenInteractiveTransition?
     
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        let flag = self.animator.areAnimationEnable
        let parent = self.config.fromViewController 
        let viewController = self.viewController(controller)
        guard !viewController.isBeingPresented else { return }
        super.show(controller, statesConfig: statesConfig, completion: completion)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        parent?.present(viewController, animated: flag, completion: completion)
       
    }
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        let viewController = self.viewController(controller)
        guard !viewController.isBeingDismissed else { return false }
        super.hide(controller, animated: flag, completion: completion)
        if self.config.isShowWithNavigationController {
            viewController.dismiss(animated: flag, completion: completion)
            return true
        } else {
            // 交给系统dismiss
            return false
        }
    }
    
    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        guard !controller.isBeingPresented else { return }
        super.interactive(present: controller, statesConfig: states)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.view.isUserInteractionEnabled = false
        interactController = UIPercentDrivenInteractiveTransition()
        self.config.fromViewController?.present(controller, animated: true, completion: nil)
    }
    
    public override func interactive(dismiss controller: WQLayoutController) {
        let viewController = self.viewController(controller)
        guard !viewController.isBeingDismissed else { return }
        super.interactive(dismiss: controller)
        interactController = UIPercentDrivenInteractiveTransition()
        viewController.dismiss(animated: true, completion: nil)
    }
    public override func interactive(update controller: WQLayoutController, progress: CGFloat, isModal: Bool) {
        super.interactive(update: controller, progress: progress, isModal: isModal)
        self.interactController?.update(progress)
    }
    public override func interactive(finish controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
        super.interactive(finish: controller, velocity: velocity, isModal: isModal)
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactController?.timingCurve = provider
        self.interactController?.finish()
        if isModal {
            controller.view.isUserInteractionEnabled = true
        }
//        self.intercatController = nil
    }
    public override func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
        super.interactive(cancel: controller, velocity: velocity, isModal: isModal)
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactController?.timingCurve = provider
        self.interactController?.cancel()
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
        return self.isInteractive ? self.interactController : nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactController : nil
    } 
}
@available(iOS 10.0, *)
extension ModalPresentationContext: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if !self.animator.areAnimationEnable {
            return 0.01
        }
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
            if self.config.isShowWithNavigationController,
               let nav = toVC as? UINavigationController,
               let showViewController = nav.topViewController as? WQLayoutController {
                self.animator.preprocessor(.show, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else if let showViewController = toVC as? WQLayoutController {
                self.animator.preprocessor(.show, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            } 
        } else {
            if self.config.isShowWithNavigationController,
               let nav = fromVC as? UINavigationController,
               let showViewController = nav.topViewController as? WQLayoutController {
                self.animator.preprocessor(.hide, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else if let showViewController = fromVC as? WQLayoutController {
                self.animator.preprocessor(.hide, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            }
        }
        
    }
}
