//
//  WQPresentTransitioningAnimator.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/15.
//

import UIKit

protocol WQTransitioningAnimatorable: NSObjectProtocol {
    func transitionAnimator(shouldAnimated animator: WQTransitioningAnimator,
                            animateView: UIView,
                            toValue: CGRect, isShow: Bool)
    func transitionAnimator(shouldAnimated animator: WQTransitioningAnimator,
                            backgroundView: UIView,
                            isShow: Bool,
                            completion: @escaping ((Bool) -> Void))
}
open class WQTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    open var viewPresentedFrame: CGRect = UIScreen.main.bounds
    open var animatedView: UIView
    open var showFrame: CGRect
    open var hideFrame: CGRect
    open var duration: TimeInterval = 0.25
    open var showBackgroundViewColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    open var initialBackgroundViewColor: UIColor = UIColor.clear
    
    weak var delegate: WQTransitioningAnimatorable?
    
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
        
        let animateCompletion: ((Bool) -> Void) = { flag -> Void in
            let success = !transitionContext.transitionWasCancelled
            if (isPresented && !success) || (!isPresented && success) {
                toVCView?.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
            //            self.transitionContext = nil
        }
        if isPresented {//初始化
            self.subViewAnimate(self.animatedView, toValue: showFrame, isShow: true)
            if let toView = toVCView {
                toView.backgroundColor = self.initialBackgroundViewColor
                self.backgroundAnimate(toView, toValue: showBackgroundViewColor, isShow: true, completion: animateCompletion)
            }
        } else {
            self.subViewAnimate(self.animatedView, toValue: hideFrame, isShow: true)
            self.backgroundAnimate(fromVC.view, toValue: initialBackgroundViewColor, isShow: false, completion: animateCompletion)
        }
    }
}
public extension WQTransitioningAnimator {
     func subViewAnimate(_ subView: UIView, toValue: CGRect, isShow: Bool = true) {
            if let delegate = self.delegate {
                delegate.transitionAnimator(shouldAnimated: self, animateView: subView, toValue: toValue, isShow: isShow)
            } else {
                defaultSubViewAnimate(subView, toValue: toValue, isShow: isShow)
        }
    }
    func backgroundAnimate(_ dimmingView: UIView, toValue: UIColor, isShow: Bool = true, completion: @escaping ((Bool) -> Void)) {
        if let delegate = self.delegate {
            delegate.transitionAnimator(shouldAnimated: self, backgroundView: dimmingView, isShow: isShow, completion: completion)
        } else {
        defaultBackgroundAnimate(dimmingView, isShow: isShow, completion: completion)
        }
    }
    func defaultSubViewAnimate(_ subView: UIView, toValue: CGRect, isShow: Bool = true) {
        UIView.animate(withDuration: self.duration,
                       delay: 0.0,
                       options: [.curveEaseIn, .layoutSubviews, .beginFromCurrentState],
                       animations: {
                        subView.frame = toValue
        })
    }
    func defaultBackgroundAnimate(_ dimmingView: UIView, isShow: Bool = true, completion: @escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: self.duration,
                       animations: {
                        if isShow {
                            dimmingView.backgroundColor = self.showBackgroundViewColor
                        } else {
                            dimmingView.backgroundColor = self.initialBackgroundViewColor
                        }
                        },
                       completion: { flag in
                        completion(flag)
                    })
    }
}
extension WQTransitioningAnimatorable {
    func transitionAnimator(shouldAnimated animator: WQTransitioningAnimator,
                            animateView: UIView,
                            toValue: CGRect,
                            isShow: Bool) {
        animator.defaultSubViewAnimate(animateView, toValue: toValue, isShow: isShow)
    }
    func transitionAnimator(shouldAnimated animator: WQTransitioningAnimator,
                            backgroundView: UIView,
                            isShow: Bool,
                            completion: @escaping ((Bool) -> Void)) {
        animator.defaultBackgroundAnimate(backgroundView, isShow: isShow, completion: completion)
    }
}
