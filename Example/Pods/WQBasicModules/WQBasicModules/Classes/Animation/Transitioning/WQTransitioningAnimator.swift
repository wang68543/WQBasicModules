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
open class WQTransitioningAnimator: NSObject {
    public struct Options {
        public var duration: TimeInterval
        public var delay: TimeInterval
        public var damping: CGFloat
        public var initialVelocity: CGFloat
        public var options: UIView.AnimationOptions

        public init(_ duration: TimeInterval = 0.25,
                    delay: TimeInterval = 0.0,
                    damping: CGFloat = 0,
                    velocity: CGFloat = 0,
                    options: UIView.AnimationOptions = []) {
             self.duration = duration
             self.delay = delay
             self.damping = damping
             self.initialVelocity = velocity
             self.options = options
        }
    }
    public enum TransitionStyle {
        case presentation
        case dismissal
    }

    @available(*, deprecated, message: "use Options.duration")
    open var duration: TimeInterval = 0.25
    /// containerView的动画类型
//    public var preferredStyle: Style = .default
    public var items: WQAnimatedConfigItems
    /// 当设置代理之后 所有的动画 以及初始化都有代理完成
    public weak var delegate: WQTransitioningAnimatorable?
    public let presentOptions: Options
    public let dismissOptions: Options
    private var willTransitionStyle: TransitionStyle = .presentation

    public init(items: WQAnimatedConfigItems = [],
                options present: Options = .normalPresent,
                dismiss: Options? = .normalDismiss) {
        self.items = items
        self.presentOptions = present
        self.dismissOptions = dismiss ?? present
        super.init()
    }
    public convenience init(_ items: WQAnimatedConfigAble ...,
                            options present: Options = .normalPresent,
                            dismiss: Options? = .normalDismiss) {
        self.init(items: items, options: present, dismiss: dismiss)
    }
}

// MARK: - --UIViewControllerAnimatedTransitioning
extension WQTransitioningAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if self.willTransitionStyle == .dismissal {
            return self.dismissOptions.duration
        } else {
            return self.presentOptions.duration
        }
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
        let animateCompletion: WQAnimateCompletion = { [weak self] flag -> Void in
            guard let weakSelf = self else {
                return
            }
            let success = !transitionContext.transitionWasCancelled
            if (isPresented && !success) || (!isPresented && success) {
                toVCView?.removeFromSuperview()
            }
            if isPresented && success {
                weakSelf.willTransitionStyle = .dismissal
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
    /// 执行动画
    ///
    /// - Parameters:
    ///   - presented: 显示其他控制器的控制器
    ///   - presenting: 被present出来的UIViewController
    ///   - isShow: 是否是显示
    ///   - completion: 动画完成
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
    /// 默认动画方式 
    func defaultAnimated(presented: UIViewController?,
                         presenting: UIViewController?,
                         isShow: Bool,
                         completion: @escaping WQAnimateCompletion) {
        let animateBlock = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.items.config(presented, presenting: presenting, isShow: isShow)
         }
        let options = isShow ? self.presentOptions : self.dismissOptions
        let duration = options.duration
        if options.isSpringAnimate {
            UIView.animate(withDuration: duration,
                           delay: options.delay,
                           usingSpringWithDamping: options.damping,
                           initialSpringVelocity: options.initialVelocity,
                           options: options.options,
                           animations: animateBlock,
                           completion: completion)

        } else {
            UIView.animate(withDuration: duration,
                           delay: options.delay,
                           options: options.options,
                           animations: animateBlock,
                           completion: completion)
        }
    }
}

// 若有代理但是没有实现动画就用代理里面的默认动画
extension WQTransitioningAnimatorable {
    func transition(shouldAnimated animator: WQTransitioningAnimator,
                    presented: UIViewController?,
                    presenting: UIViewController?,
                    isShow: Bool,
                    completion: @escaping WQAnimateCompletion) {
        animator.defaultAnimated(presented: presented, presenting: presenting, isShow: isShow, completion: completion)
    }
}

public extension WQTransitioningAnimator.Options {
    static let normalPresent = WQTransitioningAnimator.Options(options: [.layoutSubviews, .beginFromCurrentState, .curveEaseIn])
    static let normalDismiss = WQTransitioningAnimator.Options(options: [.layoutSubviews, .beginFromCurrentState, .curveEaseInOut])

    static let actionSheetPresent = WQTransitioningAnimator.Options(0.25, options: [.layoutSubviews, .beginFromCurrentState, .curveEaseOut])
    static let actionSheetDismiss = WQTransitioningAnimator.Options(0.15, options: [.layoutSubviews, .beginFromCurrentState, .curveEaseIn])

    static let alertPresent = WQTransitioningAnimator.Options(0.15,
                                                              delay: 0,
                                                              damping: 3,
                                                              velocity: 15,
                                                              options: [.layoutSubviews, .beginFromCurrentState, .curveEaseOut])
    static let alertDismiss = WQTransitioningAnimator.Options(0.15,
                                                              delay: 0,
                                                              damping: 0,
                                                              velocity: 0,
                                                              options: [.layoutSubviews, .beginFromCurrentState, .curveEaseIn])
    /// 是否是spring 动画
    var isSpringAnimate: Bool {
        return self.initialVelocity * self.damping != 0
    }
}
