//
//  TransitionModalContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/5.
//

import UIKit

public class TransitionModalContext: UIPercentDrivenInteractiveTransition, TransitionAnimateContext  {
    var transitionContext: UIViewControllerContextTransitioning?
    
}
public extension TransitionModalContext {
    func transitionPause() {
        if #available(iOS 10.0, *) {
            self.pause()
        }
    }
    
    func transitionUpdate(_ percentComplete: CGFloat) {
        self.update(percentComplete)
    }
    
    func transitionCancel(_ isInteractive: Bool) {
        if isInteractive {
            self.cancel()
//            transitionContext?.cancelInteractiveTransition()
        } else {
//            self.finish()
            transitionContext?.completeTransition(false)
        }
    }
    
     func transitionFinish(_ isInteractive: Bool) {
        if isInteractive {
            self.finish()
//            transitionContext?.finishInteractiveTransition()
        } else {
            transitionContext?.completeTransition(true)
        }
    }
}
