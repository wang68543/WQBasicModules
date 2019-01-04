//
//  WQPercentDrivenInteractiveTransition.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/15.
//

import UIKit

open class WQPercentDrivenInteractive: UIPercentDrivenInteractiveTransition {
    public enum Direction {
        case none
        case left
        case right
        case upwards
        case down
    }
    public enum InteractionType {
        case dismiss
        case present
        case push
        case pop
    }
    /// 手势开始的时候将要显示的控制器
    public typealias WQShowConfig = ((InteractionType) -> Void)
    open var direction: Direction
    /// 交互的时候 用于计算动画完成百分比的
//    open var progressSize: CGSize
    public var interactionType: InteractionType = .dismiss
    public var starShowConfig: WQShowConfig? 
    public private(set) var isInteracting: Bool = false
    public let panGesture = UIPanGestureRecognizer()
    public private(set) var transitionContext: UIViewControllerContextTransitioning?
    
    public var shouldCompletedProgress: CGFloat = 0.5
    public var shouldCompletedVelocity: CGFloat = 100
    
    public init(_ direction: Direction) {
        self.direction = direction
        self.panGesture.maximumNumberOfTouches = 1
        super.init()
        self.panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
    }
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        self.transitionContext = transitionContext
       
    }
    open func shouldBeginInteractive(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard !self.isInteracting,
            let panGR = gestureRecognizer as? UIPanGestureRecognizer,
            panGR === self.panGesture,
           let senderView = panGesture.view else {
            return false
        }
        let velocity = panGR.velocity(in: senderView)
        var isEnableGesture: Bool = false
        switch self.direction {
        case .upwards:
            isEnableGesture = velocity.y < 0 && abs(velocity.y) > abs(velocity.x)
        case .down:
            isEnableGesture = velocity.y > 0 && abs(velocity.y) > abs(velocity.x)
        case .left:
            isEnableGesture = velocity.x < 0 && abs(velocity.y) < abs(velocity.x)
        case .right:
            isEnableGesture = velocity.x > 0 && abs(velocity.y) < abs(velocity.x)
        default:
            break
        }
        return isEnableGesture 
    }
    public func shouldCompletionInteraction(_ velocity: CGPoint, translate: CGPoint, progressSize: CGSize) -> Bool {
        let size = progressSize
        var isFinished: Bool = false
        switch self.direction {
        case .down:
            let progress = translate.y / size.height
            if  velocity.y > shouldCompletedVelocity || progress > shouldCompletedProgress {
                isFinished = true
            }
        case .upwards:
            let progress = translate.y / size.height
            if abs(velocity.y) > shouldCompletedVelocity || progress > shouldCompletedProgress {
                isFinished = true
            }
        case .left:
            let progress = translate.x / size.width
            if abs(velocity.x) > shouldCompletedVelocity || progress > shouldCompletedProgress {
                isFinished = true
            }
        case .right:
            let progress = translate.x / size.width
            if velocity.x > shouldCompletedVelocity || progress > shouldCompletedProgress {
                isFinished = true
            }
        default:
            break
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
        switch sender.state {
        case .began:
            sender.setTranslation(.zero, in: view)
            self.isInteracting = true
            self.starShowConfig?(self.interactionType)
        case .changed:
            var percentage: CGFloat
            
            let translate = sender.translation(in: view)
            switch self.direction {
            case .down, .upwards:
                percentage = translate.y / size.height
            case .left, .right:
                percentage = translate.x / size.width
            default:
                percentage = 0.0
            }
            
            self.update(percentage)
        case .ended, .cancelled, .failed:
            let velocity = sender.velocity(in: view)
            let translate = sender.translation(in: view) 
            let isFinished: Bool = self.shouldCompletionInteraction(velocity, translate: translate, progressSize: size)
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
