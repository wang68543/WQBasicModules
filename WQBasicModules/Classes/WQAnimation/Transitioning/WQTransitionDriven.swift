//
//  WQTransitionDriver.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/19.
//

import UIKit

public class WQTransitionDriven: NSObject {
//    let isShow: Bool
    var panGesture: UIPanGestureRecognizer
    var direction: DrivenDirection
    
    @available(iOS 10.0, *)
    lazy var  propertyAnimations: [UIViewPropertyAnimator] = []
//    public private(set) var  propertyAnimations: [UIViewPropertyAnimator] = []
    var isInteractive: Bool = false
    ///交互的时候  手势完成长度 (用于动画完成百分比计算)
    var completionWidth: CGFloat = 0
    var shouldCompletionProgress: CGFloat = 0.5
    var shouldCompletionSpeed: CGFloat = 100
    
    internal var animateCompletion: ((Bool) -> Void)?
    
    init(_ gesture: UIPanGestureRecognizer,
         direction: DrivenDirection) {
        self.panGesture = gesture
        self.direction = direction
    }
    @available(iOS 10.0, *)
    func configAnimations(_ anmator: [UIViewPropertyAnimator]) {
        self.propertyAnimations = anmator
        if let maxDuration = anmator.max(by: { $0.duration < $1.duration }),
            let completion = self.animateCompletion {
            maxDuration.addCompletion { completion($0 == .end) }
        }
    }
    @available(iOS 10.0, *)
    @objc
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        let size = view.frame.size
        if completionWidth <= 0 {
            switch self.direction {
            case .down, .upwards:
                completionWidth = size.height
            case .left, .right:
                completionWidth = size.width
            }
        }
       
        switch sender.state {
        case .began:
            sender.setTranslation(.zero, in: view)
        case .changed:
            var percentage: CGFloat
            let translate = sender.translation(in: view)
             debugPrint("=====",translate)
            switch self.direction {
            case .down, .upwards:
                percentage = translate.y / completionWidth
            case .left, .right:
                percentage = translate.x / completionWidth
            }
            percentage = abs(percentage)
            propertyAnimations.forEach({ $0.fractionComplete = percentage })
        case .ended, .cancelled, .failed:
            let velocity = sender.velocity(in: view)
            let translate = sender.translation(in: view)
            let isFinished = self.shouldCompletionInteraction(velocity, translate: translate)
            propertyAnimations.forEach { animator in
                animator.isReversed = !isFinished
                if animator.state == .inactive {
                    animator.startAnimation()
                } else {
                    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                }
            }
            self.isInteractive = false
        default:
            break
        }
    }
}
@available(iOS 10.0, *)
public extension WQTransitionDriven {
    func isEnableDriven(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard !self.isInteractive,
            let panGR = gestureRecognizer as? UIPanGestureRecognizer,
            panGR === self.panGesture else {
                return false
        }
        return panGR.isSameDirection(self.direction)
    }
    func shouldCompletionInteraction(_ velocity: CGPoint, translate: CGPoint ) -> Bool {
        var isFinished: Bool = false
        switch self.direction {
        case .down, .upwards:
            let progress = translate.y / completionWidth
            if  abs(velocity.y) > shouldCompletionSpeed || progress > shouldCompletionProgress {
                isFinished = true
            }
        case .left, .right:
            let progress = translate.x / completionWidth
            if abs(velocity.x) > shouldCompletionSpeed || progress > shouldCompletionProgress {
                isFinished = true
            }
        }
        return isFinished
    }
}
