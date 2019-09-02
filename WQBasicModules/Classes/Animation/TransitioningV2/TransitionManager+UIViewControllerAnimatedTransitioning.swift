//
//  TransitionManager+UIViewControllerAnimatedTransitioning.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/2.
//

import Foundation
extension TransitionManager: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        delegate?.transitionManager(willTransition: self, fromViewController: fromViewController, toViewController: toViewController)
        
    }
    public func animationEnded(_ transitionCompleted: Bool) {
        self.transitionContext = nil
    }
//    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//
//    }
}
