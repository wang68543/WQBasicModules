//
//  WQPercentDrivenInteractiveTransition.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/15.
//

import UIKit

open class WQDrivenTransition: UIPercentDrivenInteractiveTransition {
    public enum Direction { 
        case left
        case right
        case upwards
        case down
    }
//    public enum InteractionType {
//        case dismiss
//        case present
//        case push
//        case pop
//    }
    /// 手势开始的时候将要显示的控制器
//    public typealias WQShowConfig = ((InteractionType) -> Void)
    open var direction: Direction
    /// 交互的时候 用于计算动画完成百分比的
//    open var progressSize: CGSize
    /// 手势完成长度 (用于动画完成百分比计算)
    public var progressWidth: CGFloat = 0
//    public var interactionType: InteractionType = .dismiss
//    public var starShowConfig: WQShowConfig?
    public var isInteracting: Bool = false
    public var panGesture: UIPanGestureRecognizer {
        didSet {
            if panGesture !== oldValue {
                self.panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
            }
        }
    }
//    public private(set) var transitionContext: UIViewControllerContextTransitioning?
    
    public var shouldCompletionProgress: CGFloat = 0.5
    public var shouldCompletionSpeed: CGFloat = 100
    
    public init(gesture: UIPanGestureRecognizer, direction: Direction) {
        self.direction = direction
        self.panGesture = gesture
        super.init()
        self.panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
    }
//    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
//        super.startInteractiveTransition(transitionContext)
//        self.transitionContext = transitionContext
//
//    }
    open func isEnableDriven(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard !self.isInteracting,
            let panGR = gestureRecognizer as? UIPanGestureRecognizer,
            panGR === self.panGesture else {
             return false
        }
        return panGR.isSameDirection(self.direction)
    }
    public func shouldCompletionInteraction(_ velocity: CGPoint, translate: CGPoint ) -> Bool {
        var isFinished: Bool = false
        switch self.direction {
        case .down, .upwards:
            let progress = translate.y / progressWidth
            if  abs(velocity.y) > shouldCompletionSpeed || progress > shouldCompletionProgress {
                isFinished = true
            }
        case .left, .right:
            let progress = translate.x / progressWidth
            if abs(velocity.x) > shouldCompletionSpeed || progress > shouldCompletionProgress {
                isFinished = true
            }
        }
        return isFinished
    }
//    open override var completionSpeed: CGFloat {
//        set {
//            super.completionSpeed = completionSpeed
//        }
//        get {
//            return 1 - self.percentComplete
//        }
//    }
    @objc
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        let size = view.frame.size
        if progressWidth <= 0 {
            switch self.direction {
            case .down, .upwards:
                progressWidth = size.height
            case .left, .right:
                progressWidth = size.width
            }
        }
        switch sender.state {
        case .began:
            sender.setTranslation(.zero, in: view) 
//            self.isInteracting = true
//            self.starShowConfig?(self.interactionType)
        case .changed:
            var percentage: CGFloat
            let translate = sender.translation(in: view)
            switch self.direction {
            case .down, .upwards:
                percentage = translate.y / progressWidth
            case .left, .right:
                percentage = translate.x / progressWidth
            }
            percentage = abs(percentage)
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
            self.isInteracting = false
        default:
            break
        }
    } 
}
public extension UIPanGestureRecognizer {
    func isSameDirection(_ direction: WQDrivenTransition.Direction) -> Bool {
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
