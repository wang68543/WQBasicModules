//
//  WQPresentationable+Transition.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2019/1/20.
//

import Foundation
// MARK: - -- UIViewControllerTransitioningDelegate
extension WQPresentationable: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard let interactive = self.hidenDriven else {
                return nil
            }
            return interactive.isInteractive ? interactive : nil
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard let interactive = self.showInteractive else {
                return nil
            }
            return interactive.isInteractive ? interactive : nil
    }
}

extension WQPresentationable: UIViewControllerAnimatedTransitioning {
    //    public func animationEnded(_ transitionCompleted: Bool) {
    //        self.hidenDriven?.isInteractive = false
    //    }
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animator.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //        if #available(iOS 10.0, *) {
        //            // do nothing
        //        } else {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        let vcFinalFrame = transitionContext.finalFrame(for: toVC)
        let isPresented = toVC.presentingViewController === fromVC
        let toVCView = transitionContext.view(forKey: .to)
        let transitionView = transitionContext.containerView
        if let toView = toVCView {
            toView.frame = vcFinalFrame
            transitionView.addSubview(toView)
        }
        let animateCompletion: WQAnimateCompletion = { flag -> Void in
            let success = !transitionContext.transitionWasCancelled
            if (isPresented && !success) || (!isPresented && success) {
                toVCView?.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
        if isPresented {
            self.animator.animated(presented: fromVC, presenting: toVC, isShow: true, completion: animateCompletion)
        } else {
            self.animator.animated(presented: toVC, presenting: fromVC, isShow: false, completion: animateCompletion)
        }
        //        }
    }
}
