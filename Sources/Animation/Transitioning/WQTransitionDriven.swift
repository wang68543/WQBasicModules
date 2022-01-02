//
//  WQPercentDrivenInteractiveTransition.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/15.
//

import UIKit
open class WQTransitionDriven: UIPercentDrivenInteractiveTransition, TransitionContext {
    open var direction: DrivenDirection
    /// 交互的时候  手势完成长度 (用于动画完成百分比计算)
    public var completionWidth: CGFloat = 0
    public var isInteractive: Bool = false
    public var panGesture: UIPanGestureRecognizer {
        didSet {
            if panGesture !== oldValue {
                self.panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
            }
        }
    }
    public var shouldCompletionProgress: CGFloat = 0.5
    public var shouldCompletionSpeed: CGFloat = 100

    public init(gesture: UIPanGestureRecognizer, direction: DrivenDirection) {
        self.direction = direction
        self.panGesture = gesture
        super.init()
        self.panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
    }
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
            let translate = sender.translation(in: view)
            let percentage = self.progress(for: translate)
            self.update(percentage)
        case .ended, .cancelled, .failed:
            let velocity = sender.velocity(in: view)
            let translate = sender.translation(in: view)
            let isFinished = self.shouldCompletionInteraction(velocity, translate: translate)
            if isFinished {
                self.completionSpeed = 1 - self.percentComplete
                self.finish()
            } else {
                self.cancel()
            }
            self.isInteractive = false
        default:
            break
        }
    }
}
