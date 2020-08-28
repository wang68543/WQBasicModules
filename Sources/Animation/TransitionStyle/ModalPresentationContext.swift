//
//  ModalPresentationContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit
//https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html
class ModalPresentationContext: ModalContext {
    lazy var driven: UIPercentDrivenInteractiveTransition = {
       let driven = UIPercentDrivenInteractiveTransition()
        return driven
    }()
    
    fileprivate var transitionContext: UIViewControllerContextTransitioning?
}
extension ModalPresentationContext: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

      
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteracting ? self.driven : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteracting ? self.driven : nil
    } 
}
extension ModalPresentationContext: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        return
//    }
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}
