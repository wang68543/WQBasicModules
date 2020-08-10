//
//  TransitionPropertyContext.swift
//  Pods
//
//  Created by WQ on 2019/9/5.
//

import UIKit
@available(iOS 10.0, *)
public class TransitionPropertyContext: NSObject, TransitionAnimateContext {
    var animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.25, timingParameters: UICubicTimingParameters(animationCurve: .easeOut))
    
    public func transitionCancel() {
        self.animator.stopAnimation(true)
    }
    
    public func transitionPause() {
        self.animator.pauseAnimation()
    }
    
    public func transitionUpdate(_ percentComplete: CGFloat) {
        self.animator.fractionComplete = percentComplete
    }
    
    public func transitionFinish() {
        self.animator.finishAnimation(at: .end)
    }
}
