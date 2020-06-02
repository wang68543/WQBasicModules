//
//  WQTransitionAnimator+Convenience.swift
//  Pods
//
//  Created by WQ on 2019/9/3.
//

import Foundation
public extension WQTransitionAnimator {
    
}

public extension WQTransitionAnimator.Options {
    static let normalPresent = WQTransitionAnimator.Options(options: [.layoutSubviews, .beginFromCurrentState, .curveEaseIn])
    static let normalDismiss = WQTransitionAnimator.Options(options: [.layoutSubviews, .beginFromCurrentState, .curveEaseInOut])
    
    static let actionSheetPresent = WQTransitionAnimator.Options(0.25, options: [.layoutSubviews, .beginFromCurrentState, .curveEaseOut])
    static let actionSheetDismiss = WQTransitionAnimator.Options(0.15, options: [.layoutSubviews, .beginFromCurrentState, .curveEaseIn])
    
    static let alertPresent = WQTransitionAnimator.Options(0.15,
                                                           delay: 0,
                                                           damping: 3,
                                                           velocity: 15,
                                                           options: [.layoutSubviews, .beginFromCurrentState, .curveEaseOut])
    static let alertDismiss = WQTransitionAnimator.Options(0.15,
                                                           delay: 0,
                                                           damping: 0,
                                                           velocity: 0,
                                                           options: [.layoutSubviews, .beginFromCurrentState, .curveEaseIn])
    /// 是否是spring 动画
    var isSpringAnimate: Bool {
        return self.initialVelocity * self.damping != 0
    }
}
