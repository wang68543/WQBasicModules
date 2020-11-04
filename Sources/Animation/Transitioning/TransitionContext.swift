//
//  TransitionContext.swift
//  Pods
//
//  Created by WQ on 2019/9/5.
//

import Foundation
/// 解决 iOS10之前以及非Modal形式的动画无法手势驱动问题
public enum DrivenDirection {
    case left
    case right
    case upwards
    case down
}

public protocol TransitionContext: UIViewControllerInteractiveTransitioning {
 
    var completionWidth: CGFloat { get set }
    var panGesture: UIPanGestureRecognizer { get set }
    var isInteractive: Bool { get set }
    var shouldCompletionSpeed: CGFloat { get set }
    var shouldCompletionProgress: CGFloat { get set }
    var direction: DrivenDirection { get set }

    func isEnableDriven(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    func progress(for translate: CGPoint) -> CGFloat
    func shouldCompletionInteraction(_ velocity: CGPoint, translate: CGPoint ) -> Bool
}

public extension TransitionContext {
    func isEnableDriven(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard !self.isInteractive,
            let panGR = gestureRecognizer as? UIPanGestureRecognizer,
            panGR === self.panGesture else {
                return false
        }
        return panGR.isSameDirection(self.direction)
    }
    
    func progress(for translate: CGPoint) -> CGFloat {
        var percentage: CGFloat
        switch self.direction {
        case .down: //向下为正
            if translate.y <= 0 {
                percentage = 0.0
            } else {
                percentage = translate.y / completionWidth
            }
        case .upwards:
            if translate.y >= 0 {
                percentage = 0.0
            } else {
                percentage = -translate.y / completionWidth
            }
        case .left:
            if translate.x >= 0 {
                percentage = 0.0
            } else {
                percentage = -translate.x / completionWidth
            }
        case .right:
            if translate.x <= 0 {
                percentage = 0.0
            } else {
                percentage = translate.x / completionWidth
            }
        }
        return percentage
    }
    
    func shouldCompletionInteraction(_ velocity: CGPoint, translate: CGPoint ) -> Bool {
        var isFinished: Bool = false
        let progress = self.progress(for: translate)
        if progress > shouldCompletionProgress {
            isFinished = true
        } else {
            let speed = shouldCompletionSpeed
            switch self.direction {
            case .down:
                isFinished = velocity.y > speed
            case .upwards:
                isFinished = -velocity.y > speed
            case .left:
                isFinished = -velocity.x > speed
            case .right:
                isFinished = velocity.x > speed
            }
        }
        return isFinished
    }
}

public extension UIPanGestureRecognizer {
    func isSameDirection(_ direction: DrivenDirection) -> Bool {
        let velocity = self.velocity(in: self.view)
        guard velocity != .zero else {
            return false
        }
        var isSame: Bool = false
        switch direction {
        case .upwards:
            isSame = velocity.y < 0 && abs(velocity.y) > abs(velocity.x)
        case .down:
            isSame = velocity.y > 0 && abs(velocity.y) > abs(velocity.x)
        case .left:
            isSame = velocity.x < 0 && abs(velocity.y) < abs(velocity.x)
        case .right:
            isSame = velocity.x > 0 && abs(velocity.y) < abs(velocity.x)
        }
        return isSame
    }
}
