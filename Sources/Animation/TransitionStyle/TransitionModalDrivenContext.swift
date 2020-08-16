//
//  TransitionModalDrivenContext.swift
//  Pods
//
//  Created by WQ on 2019/9/6.
//

import Foundation
public class TransitionModalDrivenContext: UIPercentDrivenInteractiveTransition, TransitionAnimateContext {
    public func transitionCancel() {
        self.cancel()
    }
    
    public func transitionPause() {
        if #available(iOS 10.0, *) {
            self.pause()
        }
    }
    
    public func transitionUpdate(_ percentComplete: CGFloat) {
        self.update(percentComplete)
    }
    
    public func transitionFinish() {
        self.finish()
    } 
}
