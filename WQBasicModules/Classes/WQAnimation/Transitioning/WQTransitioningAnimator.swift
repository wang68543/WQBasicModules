//
//  WQPresentTransitioningAnimator.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/15.
//  自定义动画主要有两种方式: 1.一种是设置代理 实现代理方法 2.一种是提前设置动画属性类型 (前者可以自定义动画的类型)

import UIKit

public protocol WQTransitioningAnimatorable: NSObjectProtocol {
    func transition(shouldAnimated animator: WQTransitioningAnimator,
                    presented: UIViewController?,
                    presenting: UIViewController?,
                    isShow: Bool,
                    completion: @escaping WQAnimateCompletion)
}

public enum WQTransitionState {
    /// 没有动画之前的状态
    case initial
    case show
    /// 消失的状态
    case dismiss
}

public protocol WQAnimatedConfigAble {
    
    /// 用于配置动画
    ///
    /// - Parameters:
    ///   - presented: show其它的Controller的Controller
    ///   - presenting: 被show出来的Controller
    ///   - state: 动画状态
    func config(_ presented: UIViewController?, presenting: UIViewController?, state: WQTransitionState)
}
public final class WQAnimatedItem<Element>: WQAnimatedConfigAble {
    
    public typealias Value = Element
    public typealias Root = ReferenceWritableKeyPath<WQPresentationable, Value>
    public let keyPath: Root
    public var initial: Value
    public var show: Value
    public var dismiss: Value
    
    public init(_ key: Root, initial: Value, show: Value, dismiss: Value? = nil) {
        self.keyPath = key
        self.initial = initial
        self.dismiss = dismiss ?? initial
        self.show = show
    }
    public func config(_ presented: UIViewController?, presenting: UIViewController?, state: WQTransitionState) {
        guard let presenter = presenting as? WQPresentationable else {
            return
        }
        switch state {
        case .initial:
            presenter[keyPath: self.keyPath] = self.initial
        case .show:
            presenter[keyPath: self.keyPath] = self.show
        case .dismiss:
            presenter[keyPath: self.keyPath] = self.dismiss
        }
    }
    
}
public extension WQAnimatedItem where Element == UIColor? {
    class func defaultViewBackground(_ show: UIColor = UIColor.black.withAlphaComponent(0.6),
                                     initial: UIColor = UIColor.black.withAlphaComponent(0.3)) -> WQAnimatedItem {
        let keyPath = \WQPresentationable.view.backgroundColor
        return WQAnimatedItem(keyPath, initial: initial, show: show)
    }
}
public extension WQAnimatedItem where Element == CGRect {
    class func defaultViewShowFrame(_ show: CGRect = UIScreen.main.bounds,
                                    initial: CGRect = UIScreen.main.bounds) -> WQAnimatedItem {
        let keyPath = \WQPresentationable.view.frame
        return WQAnimatedItem(keyPath, initial: initial, show: show)
    }
}
public typealias WQAnimatedConfigItems = [WQAnimatedConfigAble]
public extension Array where Element == WQAnimatedConfigAble {
    func initial(_ presented: UIViewController?, presenting: UIViewController?) {
        self.setup(presented, presenting: presenting, state: .initial)
    }
    func config(_ presented: UIViewController?, presenting: UIViewController?, isShow: Bool) {
        self.setup(presented, presenting: presenting, state: isShow ? .show : .dismiss)
    }
    func setup(_ presented: UIViewController?, presenting: UIViewController?, state: WQTransitionState) {
        self.forEach { item in
            item.config(presented, presenting: presenting, state: state)
        }
    }
}
public typealias WQAnimateCompletion = ((Bool) -> Void)
open class WQTransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
 
    open var duration: TimeInterval = 0.25
    public var items: WQAnimatedConfigItems
    public weak var delegate: WQTransitioningAnimatorable?
    
    public init(_ presenter: WQPresentationable, items: WQAnimatedConfigItems) {
        self.items = items
        super.init()
//        if let index =  items.first(where: { $0 == \WQPresentationable.view.frame }) {
//
//        }
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
extension WQTransitioningAnimatorable {
    func transition(shouldAnimated animator: WQTransitioningAnimator,
                    presented: UIViewController?,
                    presenting: UIViewController?,
                    isShow: Bool,
                    completion: @escaping WQAnimateCompletion) {
        animator.defaultAnimated(presented: presented, presenting: presenting, isShow: isShow, completion: completion)
    }
}
