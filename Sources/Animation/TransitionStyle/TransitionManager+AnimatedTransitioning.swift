//
//  TransitionManager+UIViewControllerAnimatedTransitioning.swift
//  Pods
//
//  Created by WQ on 2019/9/2.
//

import Foundation
extension TransitionManager: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.preprocessor.preprocessor(duration: self)
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.preprocessor.preprocessor(willTransition: self) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
//        let modalContext = TransitionModalContext()
//        modalContext.transitionContext = transitionContext
//        self.context = modalContext
//        if #available(iOS 10.0, *) {
//            let propertyContext = TransitionPropertyContext()
//            propertyContext.animator.addAnimations {
//
//            }
//
//        }
        
//        self.startAnimate()
//        let fromViewController = transitionContext.viewController(forKey: .from)
//        let toViewController = transitionContext.viewController(forKey: .to)
//        let isShow = toViewController?.presentingViewController === fromViewController
////        if isShow {
////             delegate?.transitionManager(willShow: self, fromViewController: fromViewController, toViewController: toViewController)
////        } else {
////            delegate?.transitionManager(willHide: self, fromViewController: toViewController, toViewController: fromViewController)
////        }
    }
    public func animationEnded(_ transitionCompleted: Bool) {
//        self.transitionContext = nil
    }
//    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//
//    }
}
extension TransitionManager {
    func startAnimate() {
//        if self.isShow {
//            self.delegate?.transitionManager(willShow: self,
//                                             fromViewController: self.showFromViewController,
//                                             toViewController: self.showViewController)
//        } else {
//            self.delegate?.transitionManager(willHide: self,
//                                             fromViewController: self.showFromViewController,
//                                             toViewController: self.showViewController)
//        }
    }
}
