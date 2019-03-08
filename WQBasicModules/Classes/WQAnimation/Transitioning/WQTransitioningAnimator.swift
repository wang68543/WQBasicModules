//
//  WQPresentTransitioningAnimator.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/15.
//  自定义动画主要有两种方式: 1.一种是设置代理 实现代理方法 2.一种是提前设置动画属性类型 (前者可以自定义动画的类型)

import UIKit

public protocol WQTransitioningAnimatorable: NSObjectProtocol {
    func transition(shouldAnimated animator: WQTransitioningAnimator,
                    presented: UIViewController?, //当以独立window的形式显示的时候 这里为空
                    presenting: UIViewController?,
                    isShow: Bool,
                    completion: @escaping WQAnimateCompletion)
}

public typealias WQAnimateCompletion = ((Bool) -> Void)
open class WQTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    open var duration: TimeInterval = 0.25
    public var items: WQAnimatedConfigItems
    /// 当设置代理之后 所有的动画 以及初始化都有代理完成
    public weak var delegate: WQTransitioningAnimatorable?
    
    public init(items: WQAnimatedConfigItems = [], delegate: WQTransitioningAnimatorable? = nil) {
        assert(!items.isEmpty || delegate != nil, "请选择属性动画或者代理自定义动画方式其中一种(优先使用代理动画)")
        self.items = items
        self.delegate = delegate
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
        let transitionView = transitionContext.containerView
        if let toView = toVCView {
            toView.frame = vcFinalFrame
            transitionView.addSubview(toView)
        }
        let animateCompletion: WQAnimateCompletion = { flag -> Void in
            let success = !transitionContext.transitionWasCancelled
            if (isPresented && !success) || (!isPresented && success) {
                toVCView?.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
        if isPresented {
           animated(presented: fromVC, presenting: toVC, isShow: true, completion: animateCompletion)
        } else {
            animated(presented: toVC, presenting: fromVC, isShow: false, completion: animateCompletion)
        }
    }
}
public extension WQTransitioningAnimator {
    func animated(presented: UIViewController?,
                  presenting: UIViewController?,
                  isShow: Bool,
                  completion: @escaping WQAnimateCompletion) {
        if let delegate = self.delegate {
            delegate.transition(shouldAnimated: self, presented: presented, presenting: presenting, isShow: isShow, completion: completion)
        } else {
            self.defaultAnimated(presented: presented, presenting: presenting, isShow: isShow, completion: completion)
        }
    }
    func defaultAnimated(presented: UIViewController?,
                         presenting: UIViewController?,
                         isShow: Bool,
                         completion: @escaping WQAnimateCompletion) {
        var options: UIView.AnimationOptions = [.layoutSubviews, .beginFromCurrentState]//
        if isShow {
            options.insert(.curveEaseIn)
        } else {
            options.insert(.curveEaseInOut)
        }
        let animateBlock = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.items.config(presented, presenting: presenting, isShow: isShow)
         }
        UIView.animate(withDuration: self.duration,
                       delay: 0,
                       options: options,
                       animations: animateBlock,
                       completion: completion)
    }
}

// MARK: - -- convenice init
public extension WQTransitioningAnimator {
    convenience
    init(container initial: CGRect,
         show: CGRect,
         dismiss: CGRect? = nil,
         presentedFrame: CGRect = UIScreen.main.bounds) {
        let item = WQAnimatedItem(containerFrame: initial, show: show, dismiss: dismiss)
        let items = Array(default: item, viewFrame: presentedFrame)
        self.init(items: items)
    }
    
    /// 根据TransitionType计算containerView 三个状态的尺寸
    ///
    /// - Parameters:
    ///   - subView: 显示的View
    ///   - size: contianerView size
    ///   - initial: 初始的方位
    ///   - show: 显示的w方位
    ///   - dismiss: 消失的方位
    ///   - presentedFrame: 控制器的尺寸
    convenience
    init(size: CGSize,
         initial: WQPresentionStyle.Position,
         show: WQPresentionStyle.Position,
         dismiss: WQPresentionStyle.Position? = nil,
         presentedFrame: CGRect = UIScreen.main.bounds) {
        let item = WQAnimatedItem(container: size, initial: initial, show: show, dismiss: dismiss, presentedFrame: presentedFrame)
        let items = Array(default: item, viewFrame: presentedFrame)
        self.init(items: items)
    }
    /// 根据position和size来显示View
    ///
    /// - Parameters:
    ///   - subView: 显示的View
    ///   - point: contianerView的position(计算的时候回包含anchorPoint)
    ///   - size: contianerView的size
    ///   - bounceType: contianerView展开类型
    ///   - presentedFrame: 控制器的尺寸
    convenience
    init(anchor point: CGPoint,
         position: CGPoint,
         size: CGSize,
         bounceStyle: WQPresentionStyle.Bounce = .horizontalMiddle,
         presentedFrame: CGRect = UIScreen.main.bounds) {
        let item = WQAnimatedItem(container: position, anchor: point, size: size, bounceStyle: bounceStyle, presentedFrame: presentedFrame)
        self.init(items: Array(default: item, viewFrame: presentedFrame))
    }
    
    convenience
    init(position subView: UIView,
         show: WQPresentionStyle.Position,
         size: CGSize,
         bounceStyle: WQPresentionStyle.Bounce = .horizontalMiddle,
         presentedFrame: CGRect = UIScreen.main.bounds) {
        let item = WQAnimatedItem(container: size, postionStyle: show, bounceStyle: bounceStyle, presentedFrame: presentedFrame)
        self.init(items: Array(default: item, viewFrame: presentedFrame))
    }
}
extension WQTransitioningAnimatorable {
    func transition(shouldAnimated animator: WQTransitioningAnimator,
                    presented: UIViewController?,
                    presenting: UIViewController?,
                    isShow: Bool,
                    completion: @escaping WQAnimateCompletion) {
        animator.defaultAnimated(presented: presented, presenting: presenting, isShow: isShow, completion: completion)
    }
}
