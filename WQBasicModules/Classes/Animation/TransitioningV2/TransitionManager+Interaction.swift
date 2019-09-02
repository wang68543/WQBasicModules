//
//  TransitionManager+Interaction.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/2.
//

import Foundation
public extension TransitionManager {
    @available(iOS 10.0, *)
    func pause() {
        self.transitionContext?.pauseInteractiveTransition()
    }
    func update(_ percentComplete: CGFloat) {
        self.transitionContext?.updateInteractiveTransition(percentComplete)
    }
    
    func cancel() {
//        fractionComplete = 0.0
        self.transitionContext?.completeTransition(false)
    }
    
    func finish() {
//        fractionComplete = 1.0
        self.transitionContext?.completeTransition(true)
    }
}
