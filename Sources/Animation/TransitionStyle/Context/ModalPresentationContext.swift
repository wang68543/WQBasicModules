//
//  ModalPresentationContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit
//https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html
open class ModalPresentationContext: ModalContext {
//    lazy var driven: UIPercentDrivenInteractiveTransition = {
//       let driven = UIPercentDrivenInteractiveTransition()
//        return driven
//    }()
    
 
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
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
        switch styleConfig.showStyle {
        case .alert, .actionSheet:
            self.animator.duration = 0.25
        default:
            break
        }
        // 交给系统dismiss
        return false
    }
    
}
extension ModalPresentationContext: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

      
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return self.config.interactionDismiss.isGestureDrivenDismiss ? self.driven : nil
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
//        return self.config.interactionDismiss.isGestureDrivenDismiss ? self.driven : nil
    } 
}
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
//            self.statesConfig.showControllerFrame = vcFinalFrame
            toVCView?.frame = vcFinalFrame
            if let showViewController = toVC as? WQLayoutController {
                self.animator.preprocessor(.show, layoutController: showViewController, config: config, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            } 
        } else {
            if let showViewController = fromVC as? WQLayoutController {
                self.animator.preprocessor(.hide, layoutController: showViewController, config: config, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            }
        }
        
    }
//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        return
//    }
    public func animationEnded(_ transitionCompleted: Bool) {
        
    }
}
