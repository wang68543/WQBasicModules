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
        
        init(_ duration: TimeInterval = 0.25,
             delay: TimeInterval = 0.0,
             damping: CGFloat = 0,
            velocity: CGFloat = 0,
            options:UIView.AnimationOptions = []) {
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
    public var preferredStyle: Style = .default
    public var items: WQAnimatedConfigItems
    /// 当设置代理之后 所有的动画 以及初始化都有代理完成
    public weak var delegate: WQTransitioningAnimatorable?
//    public let presentOptions: Options
//    public let dismissOptions: Options
    private var transitionStyle: TransitionStyle = .presentation
//    public init(items: WQAnimatedConfigItems = [],
//                presentOptions: Options,
//                dismissOptions: Options? = nil) {
//         self.items = items
////        self.preferredStyle = preferredStyle
//        self.presentOptions = presentOptions
//        self.dismissOptions = dismissOptions ?? presentOptions
//        super.init()
//    }
    public init(items: WQAnimatedConfigItems = [], preferredStyle: Style = .default) {
        self.items = items
        self.preferredStyle = preferredStyle
        super.init()
    }
    public convenience init(_ items: WQAnimatedConfigAble ..., preferredStyle: Style = .default) {
        self.init(items: items, preferredStyle: preferredStyle)
    }
}
 
// MARK: - --UIViewControllerAnimatedTransitioning
extension WQTransitioningAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
//        if self.transitionStyle == .dismissal {
//            return self.dismissOptions.duration
//        } else {
//            return self.presentOptions.duration
//        }
//        return self.transitionStyle ==
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
extension WQTransitioningAnimator {
    public enum Style {
        case `default`
        case actionSheet(size: CGSize)
        case alert(size: CGSize)
    }
    /// 执行动画
    ///
    /// - Parameters:
    ///   - presented: 显示其他控制器的控制器
    ///   - presenting: 被present出来的UIViewController
    ///   - isShow: 是否是显示
    ///   - completion: 动画完成
    public
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
    public
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
            guard let weakSelf = self else { return }
            weakSelf.items.config(presented, presenting: presenting, isShow: isShow)
         }
        UIView.animate(withDuration: self.duration,
                       delay: 0,
                       options: options,
                       animations: animateBlock,
                       completion: completion)
        guard let presentingVC = presenting as? WQPresentationable else { return }
        self.handlePreferredStyle(presenting: presentingVC, isShow: isShow)
    }
    /// 单独处理中间View的特殊动画效果
    private func handlePreferredStyle(presenting: WQPresentationable, isShow: Bool) {
        let viewW = presenting.view.frame.width
        let viewH = presenting.view.frame.height
        let containerView = presenting.containerView
        let options: UIView.AnimationOptions = [.layoutSubviews, .beginFromCurrentState, .curveEaseOut]
        switch preferredStyle {
        case let .actionSheet(size):
            if isShow {
                containerView.frame = CGRect(x: (viewW - size.width) * 0.5, y: viewH - size.height, width: size.width, height: size.height)
                containerView.transform = CGAffineTransform(translationX: 0, y: size.height)
            }
            UIView.animate(withDuration: self.duration, delay: 0, options: options, animations: {
                if isShow {
                    containerView.transform = CGAffineTransform.identity
                } else {
                    containerView.transform = CGAffineTransform(translationX: 0, y: size.height)
                }
            }, completion: nil)
        case let .alert(size):
            if isShow { // 初始化
                containerView.frame = CGRect(x: (viewW - size.width) * 0.5,
                                             y: (viewH - size.height) * 0.5,
                                             width: size.width,
                                             height: size.height)
                containerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            }
            if isShow {
                UIView.animate(withDuration: self.duration,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 15,
                               options: options,
                               animations: {
                                containerView.transform = CGAffineTransform.identity
                },
                               completion: nil)
            } else {
                UIView.animate(withDuration: self.duration, delay: 0, options: options, animations: {
                    containerView.removeFromSuperview()
                }, completion: nil)
            }
        default:
            break
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

extension WQTransitioningAnimator.Options {
    static let normal = WQTransitioningAnimator.Options(options: [.layoutSubviews, .beginFromCurrentState, .curveEaseOut])
}
