//
//  WQTransitionDriver.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/19.
//  根据属性的最终效果和当前的效果进行比例计算 (如果最终效果是0 可能比例计算一直是0例如:transform scale)

import UIKit
@available(iOS 10.0, *)
public typealias PropertyAnimateCompletion = ((UIViewAnimatingPosition) -> Void)
@available(iOS 10.0, *)
public class WQPropertyDriven: NSObject, TransitionContext {
  
    var isShow: Bool = false
    public var panGesture: UIPanGestureRecognizer
    public var direction: DrivenDirection
    var items: WQAnimatedConfigItems
    public private(set) var transitionContext: UIViewControllerContextTransitioning?
    var transitionAnimator: UIViewPropertyAnimator?
    public var isInteractive: Bool = false
    ///交互的时候  手势完成长度 (用于动画完成百分比计算)
    public var completionWidth: CGFloat = 0
    public var shouldCompletionProgress: CGFloat = 0.5
    public var shouldCompletionSpeed: CGFloat = 100
    
    init(_ gesture: UIPanGestureRecognizer,
         items: WQAnimatedConfigItems,
         direction: DrivenDirection,
         isShow: Bool) {
        self.items = items
        self.panGesture = gesture
        self.direction = direction
        super.init()
        self.panGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
    }
    
    @objc
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
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
            self.transitionContext?.updateInteractiveTransition(percentage)
            self.transitionAnimator?.fractionComplete = percentage
        case .ended, .cancelled, .failed:
            let velocity = sender.velocity(in: view)
            let translate = sender.translation(in: view)
            let isFinished = self.shouldCompletionInteraction(velocity, translate: translate)
            self.transitionAnimator?.isReversed = !isFinished
            if self.transitionAnimator?.state == .inactive {
                self.transitionAnimator?.startAnimation()
            } else {
                self.transitionAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
            if isFinished {
                self.transitionContext?.finishInteractiveTransition()
            } else {
                self.transitionContext?.cancelInteractiveTransition()
            } 
            self.isInteractive = false
            self.transitionContext = nil
            self.transitionAnimator = nil
        default:
            break
        }
    }
    public func startIneractive(presented: UIViewController?, presenting: UIViewController?, completion: PropertyAnimateCompletion?) {
        self.transitionAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            if self.isShow {
                self.items.config(presented, presenting: presenting, isShow: true)
            } else {
                self.items.config(presented, presenting: presenting, isShow: false)
            }
        })
        if let completion = completion {
            self.transitionAnimator?.addCompletion(completion)
        }
        if !self.isInteractive {
            self.transitionAnimator?.startAnimation()
        }
    }
    public func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        self.transitionAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            if self.isShow {
                self.items.config(fromVC, presenting: toVC, isShow: true)
            } else {
                self.items.config(toVC, presenting: fromVC, isShow: false)
            }
        })
        self.transitionContext = transitionContext
        let toVCView = transitionContext.view(forKey: .to)
        if isShow {
            let vcFinalFrame = transitionContext.finalFrame(for: toVC)
            let transitionView = transitionContext.containerView
            if let toView = toVCView {
                toView.frame = vcFinalFrame
                transitionView.addSubview(toView)
            }
        }
        self.transitionAnimator?.addCompletion({ position in 
            let completed = (position == .end)
            if (self.isShow && !completed) || (!self.isShow && completed) {
                toVCView?.removeFromSuperview()
            }
            transitionContext.completeTransition(completed)
        })
        if !transitionContext.isInteractive {
            self.transitionAnimator?.startAnimation()
        }
    }
    
    public var wantsInteractiveStart: Bool {
        return self.isInteractive
    }
}
