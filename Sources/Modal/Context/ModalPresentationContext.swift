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
    private var interactAnimator: UIPercentDrivenInteractiveTransition?
     
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        let flag = self.animator.animationEnable
        let parent = self.config.fromViewController 
        let viewController = self.viewController(controller)
        guard !viewController.isBeingPresented else { return }
        super.show(controller, statesConfig: statesConfig, completion: completion)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        if flag {
            parent?.present(viewController, animated: flag, completion: completion)
        } else {
            controller.view.frame = self.config.showControllerFrame
            parent?.present(viewController, animated: flag, completion: {
                self.show(fromVC: parent, toVC: viewController, completion: completion)
            })
        }
    }
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) { // -> Bool
        let viewController = self.viewController(controller)
        guard !viewController.isBeingDismissed else { return }
        super.hide(controller, animated: flag, completion: completion)
        if flag {
            if self.config.isShowWithNavigationController {
                viewController.dismiss(animated: flag, completion: completion)
            } else {
                controller.dismiss(animated: flag, completion: completion)
            }
        } else { // 解决 非动画的时候 问题
            let group = DispatchGroup()
            group.enter()
            self.hide(fromVC: controller, toVC: self.config.fromViewController) {
                group.leave()
            }
            if self.config.isShowWithNavigationController {
                group.enter()
                viewController.dismiss(animated: flag) {
                    group.leave()
                }
            } else {
                group.enter()
                controller.dismiss(animated: flag) {
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion?()
            }
        }
    }
    
    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        let viewController = self.viewController(controller)
        guard !viewController.isBeingPresented else { return }
        super.interactive(present: controller, statesConfig: states)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        interactAnimator = UIPercentDrivenInteractiveTransition()
        self.config.fromViewController?.present(viewController, animated: true, completion: nil)
    }
    
    public override func interactive(dismiss controller: WQLayoutController) {
        let viewController = self.viewController(controller)
        guard !viewController.isBeingDismissed else { return }
        super.interactive(dismiss: controller)
        interactAnimator = UIPercentDrivenInteractiveTransition()
        viewController.dismiss(animated: true, completion: nil)
    }
    public override func interactive(update progress: CGFloat) {
        super.interactive(update: progress)
        self.interactAnimator?.update(progress)
    }
    public override func interactive(finish velocity: CGPoint) {
        super.interactive(finish: velocity)
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactAnimator?.timingCurve = provider
        self.interactAnimator?.finish()
    }
    public override func interactive(cancel velocity: CGPoint) {
        super.interactive(cancel: velocity)
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactAnimator?.timingCurve = provider
        self.interactAnimator?.cancel()
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
        return self.isInteractive ? self.interactAnimator : nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactAnimator : nil
    } 
}
@available(iOS 10.0, *)
extension ModalPresentationContext: UIViewControllerAnimatedTransitioning {
    /// 如果没有动画不走这里
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
            self.show(fromVC: fromVC, toVC: toVC, completion: completionBlock)
        } else {
            self.hide(fromVC: fromVC, toVC: toVC, completion: completionBlock)
        }
        
    }
}

@available(iOS 10.0, *)
extension ModalPresentationContext {
    func show(fromVC: UIViewController?, toVC: UIViewController?, completion: (() -> Void)?) {
        if self.config.isShowWithNavigationController,
           let nav = toVC as? UINavigationController,
           let showViewController = nav.topViewController as? WQLayoutController {
            self.animator.preprocessor(.show, layoutController: showViewController, states: styleConfig, completion: completion)
        } else if let showViewController = toVC as? WQLayoutController {
            self.animator.preprocessor(.show, layoutController: showViewController, states: styleConfig, completion: completion)
        } else {
            completion?()
        }
    }
    func hide(fromVC: UIViewController?, toVC: UIViewController?, completion: (() -> Void)?) {
        if self.config.isShowWithNavigationController,
           let nav = fromVC as? UINavigationController,
           let showViewController = nav.topViewController as? WQLayoutController {
            self.animator.preprocessor(.hide, layoutController: showViewController, states: styleConfig, completion: completion)
        } else if let showViewController = fromVC as? WQLayoutController {
            self.animator.preprocessor(.hide, layoutController: showViewController, states: styleConfig, completion: completion)
        } else {
            completion?()
        }
    }
}
