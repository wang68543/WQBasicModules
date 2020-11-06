//
//  ModalPresentationContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit
//https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html
open class ModalPresentationContext: ModalContext {
    lazy var driven: UIPercentDrivenInteractiveTransition = {
       let driven = UIPercentDrivenInteractiveTransition()
        return driven
    }()
    
 
    public override func show(_ controller: WQLayoutController, statesConfig: TransitionStatesConfig, completion: (() -> Void)?) {
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        switch statesConfig.showStyle {
        case .alert, .actionSheet:
            self.animator.duration = 0.45
        default:
            break
        }
        self.animator.preprocessor(.willShow, layoutController: controller, config: config, states: statesConfig) { [weak self] in
            guard let `self` = self else { return }
            self.config.fromViewController?.present(controller, animated: self.animator.areAnimationEnable, completion: completion)
//            self.animator.preprocessor(.show, layoutController: controller, config: self.config, states: self.statesConfig, completion: completion)
        }
    }
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        switch statesConfig.showStyle {
        case .alert, .actionSheet:
            self.animator.duration = 0.25
        default:
            break
        }
        self.animator.preprocessor(.willHide, layoutController: controller, config: config, states: self.statesConfig, completion: completion)
        return false
    }
//    var presenter: UIViewController?
    
//    public override init(_ viewController: WQLayoutController, style: ModalStyle) {
//        super.init(viewController, style: style)
//        viewController.modalPresentationStyle = .custom
//        viewController.transitioningDelegate = self
//    }
//    
//    /// 开始当前的ViewController转场动画
//    /// - Parameters:
//    ///   - viewController: 承载present的viewController
//    public func show(in viewController: UIViewController?, animated flag: Bool, completion: ModalContext.Completion? = nil) {
////        super.show(in: viewController, animated: flag, completion: completion)
//        showViewController.transitioningDelegate = self
//        showViewController.modalPresentationStyle = .custom
//        fromViewController?.present(showViewController, animated: flag, completion: completion)
//    }
//    public  func dismiss(animated flag: Bool, completion: ModalContext.Completion? = nil) {
//        showViewController.dismiss(animated: flag, completion: completion)
//    }
    
    
    
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
        return self.config.interactionDismiss.isGestureDrivenDismiss ? self.driven : nil
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
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        if isPresented {
            self.config.containerViewControllerFinalFrame = vcFinalFrame
            transitionContext.containerView.addSubview(toVC.view)
            if let showViewController = toVC as? WQLayoutController {
                self.animator.preprocessor(.show, layoutController: showViewController, config: config, states: statesConfig, completion: completionBlock)
            } else {
                completionBlock()
            } 
        } else {
            transitionContext.containerView.addSubview(toVC.view)
            if let showViewController = fromVC as? WQLayoutController {
                self.animator.preprocessor(.hide, layoutController: showViewController, config: config, states: statesConfig, completion: completionBlock)
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
