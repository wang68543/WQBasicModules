//
//  WQTransitionAnimator+Style.swift
//  Pods
//
//  Created by WQ on 2019/8/27.
//

import Foundation
extension WQTransitionAnimator: UIViewControllerTransitioningDelegate {
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
            return nil
//            guard let interactive = self.hidenDriven else { return nil }
//            return interactive.isInteractive ? interactive : nil
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return nil
//            guard let interactive = self.showDriven else { return nil }
//            return interactive.isInteractive ? interactive : nil
    }
}
public extension WQTransitionAnimator {
//    func show(_ fromViewController: UIViewController?,
//              toViewController: UIViewController?,
//              showType: )
}
