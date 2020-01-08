//
//  TransitionManager+ViewControllerTransitioningDelegate.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/2.
//  swiftlint:disable line_length

import Foundation
extension TransitionManager: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isShow = true
        return self
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isShow = false
        return self
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard self.isInteractive else {
            return nil
        }
        self.isShow = true
        let drivenContext = TransitionModalDrivenContext()
        self.context = drivenContext
        return drivenContext
    }
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard self.isInteractive else {
            return nil
        }
        self.isShow = false
        let drivenContext = TransitionModalDrivenContext()
        self.context = drivenContext
        return drivenContext
    }  
    //    @available(iOS 8.0, *)
    //    optional func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
}
