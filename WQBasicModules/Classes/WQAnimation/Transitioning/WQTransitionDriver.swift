//
//  WQTransitionDriver.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/19.
//

import UIKit

@available(iOS 10.0, *)
class WQTransitionDriver: NSObject {
    var transitionAnimator: UIViewPropertyAnimator!
    var isInteractive: Bool { return transitionContext.isInteractive }
    let transitionContext: UIViewControllerContextTransitioning
    open var direction: DrivenDirection
    ///交互的时候  手势完成长度 (用于动画完成百分比计算)
    public var completionWidth: CGFloat = 0
    public var isInteracting: Bool = false
    public var panGesture: UIPanGestureRecognizer {
        didSet {
            if panGesture !== oldValue {
                self.panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
            }
        }
    }
    public var shouldCompletionProgress: CGFloat = 0.5
    public var shouldCompletionSpeed: CGFloat = 100
    
    public init(items: WQAnimatedConfigItems,
                context: UIViewControllerContextTransitioning,
                gesture: UIPanGestureRecognizer,
                direction: DrivenDirection,
                isShow: Bool) {
        self.direction = direction
        self.panGesture = gesture
        self.transitionContext = context
        super.init()
        self.panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        let fromViewController = context.viewController(forKey: .from)!
        let toViewController = context.viewController(forKey: .to)!
        
        let fromView = fromViewController.view!
        let toView = toViewController.view!
        let containerView = context.containerView
        if isShow {
            items.initial(fromViewController, presenting: toViewController)
        }
        
        // The duration of the transition, if uninterrupted
        let transitionDuration: TimeInterval = 0.25
        
        // Create a UIViewPropertyAnimator that lives the lifetime of the transition
        transitionAnimator = UIViewPropertyAnimator(duration: transitionDuration, curve: .easeOut, animations: {
            items.config(fromViewController, presenting: toViewController, isShow: isShow)
        })
        
        transitionAnimator.addCompletion { [unowned self] (position) in
            // Call the supplied completion
//            transitionCompletion(position)
            
            
            // Inform the transition context that the transition has completed
            let completed = (position == .end)
            self.transitionContext.completeTransition(completed)
        }
        
    }
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
            //这里外部监听事件处理
            //            self.isInteracting = true
        //            self.starShowConfig?(self.interactionType)
        case .changed:
            var percentage: CGFloat
            let translate = sender.translation(in: view)
            switch self.direction {
            case .down, .upwards:
                percentage = translate.y / completionWidth
            case .left, .right:
                percentage = translate.x / completionWidth
            }
            percentage = abs(percentage)
            transitionAnimator.fractionComplete = percentage
        case .ended, .cancelled, .failed:
            let velocity = sender.velocity(in: view)
            let translate = sender.translation(in: view)
            let isFinished = self.shouldCompletionInteraction(velocity, translate: translate)
            self.transitionAnimator.addCompletion { flag  in
                
            }
//            if isFinished {
//                self.completionSpeed = 1 - self.percentComplete
//                self.finish()
//            } else {
//                self.cancel()
//            }
            self.isInteracting = false
        default:
            break
        }
    }
}
