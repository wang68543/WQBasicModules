//
//  WQPresentTransitioningAnimator.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/15.
//

import UIKit

public protocol WQTransitioningAnimatorable: NSObjectProtocol {
    func transition(shouldAnimated animator: WQTransitioningAnimator,
                    dimmingView: UIView,
                    animatedView: UIView,
                    isShow: Bool,
                    completion: @escaping WQAnimateCompletion)
}
public typealias WQAnimateCompletion = ((Bool) -> Void)
open class WQTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
   
    open var viewPresentedFrame: CGRect = UIScreen.main.bounds
    open var animatedView: UIView
    open var showFrame: CGRect
    open var hideFrame: CGRect
    open var duration: TimeInterval = 0.35
    open var showBackgroundViewColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    open var initialBackgroundViewColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    
    public weak var delegate: WQTransitioningAnimatorable?
    
    public init(_ animatedView: UIView, show: CGRect, hide: CGRect) {
        self.animatedView = animatedView
        self.showFrame = show
        self.hideFrame = hide
        super.init()
    }
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        let vcFinalFrame = transitionContext.finalFrame(for: toVC)
        let isPresented = toVC.presentingViewController === fromVC
        let toVCView = transitionContext.view(forKey: .to)
        //        self.transitionContext = transitionContext
        let transitionView = transitionContext.containerView
        if let toView = toVCView {
            toView.frame = vcFinalFrame
            transitionView.addSubview(toView)
        }
        let animateCompletion: WQAnimateCompletion = { flag -> Void in
            let success = !transitionContext.transitionWasCancelled
//            if (isPresented && !success) || (!isPresented && success)  {
//                toVCView?.removeFromSuperview()
//            }
            transitionContext.completeTransition(success)
        }
        if isPresented {//初始化
            toVC.view.backgroundColor = self.initialBackgroundViewColor
        }
        if let dimingView = isPresented ? toVC.view : fromVC.view {
           self.defaultAnimated(dimingView, animatedView: self.animatedView, isShow: isPresented, completion: animateCompletion)
        }
        
    }
}
public extension WQTransitioningAnimator {
    func defaultAnimated(_ dimingView: UIView, animatedView: UIView, isShow: Bool, completion: @escaping WQAnimateCompletion) {
        var options: UIView.AnimationOptions = [.layoutSubviews, .beginFromCurrentState]//
        if isShow {
            options.insert(.curveEaseIn)
        } else {
            options.insert(.curveEaseInOut)
        }
        let animateBlock = {
             animatedView.frame = isShow ? self.showFrame : self.hideFrame
             dimingView.backgroundColor = isShow ? self.showBackgroundViewColor : self.initialBackgroundViewColor
         }
        UIView.animate(withDuration: self.duration,
                       delay: 0,
                       options: options,
                       animations: animateBlock,
                       completion: completion)
    }
}
extension WQTransitioningAnimatorable {
    func transition(shouldAnimated animator: WQTransitioningAnimator,
                    dimmingView: UIView,
                    animatedView: UIView,
                    isShow: Bool,
                    completion: @escaping WQAnimateCompletion) {
        animator.defaultAnimated(dimmingView,
                                 animatedView: animatedView,
                                 isShow: isShow,
                                 completion: completion)
    } 
}
