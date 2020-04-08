//
//  TransitionModalContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/5.
//

import UIKit
/// 控制器之间的转场都用这个  手势驱动也用这个
public class TransitionModalContext: UIPercentDrivenInteractiveTransition, TransitionAnimateContext {
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
    
    func transitionCancel() {
//        if isInteractive {
//            self.cancel()
////            transitionContext?.cancelInteractiveTransition()
//        } else {
////            self.finish()
//            transitionContext?.completeTransition(false)
//        }
    }
    
     func transitionFinish() {
//        if isInteractive {
//            self.finish()
////            transitionContext?.finishInteractiveTransition()
//        } else {
//            transitionContext?.completeTransition(true)
//        }
    }
}
