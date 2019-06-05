//
//  WQPresentedAnimatedItem.swift
//  Pods
//
//  Created by WangQiang on 2019/1/14.
//

import Foundation
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
    ///   - presented: show其它的Controller的Controller(是NavgationController或者UITabBarController)
    ///   - presenting: 被show出来的Controller
    ///   - state: 动画状态
    func config(_ presented: UIViewController?, presenting: UIViewController?, present state: WQTransitionState)
    
    @available(iOS 10.0, *)
    func setup(_ presented: UIViewController?, presenting: UIViewController?, present state: WQTransitionState) -> UIViewPropertyAnimator
}
 
// MARK: - -- 手势驱动动画的目标状态
public extension WQAnimatedConfigAble {
    @available(iOS 10.0, *)
    func setup(_ presented: UIViewController?, presenting: UIViewController?, present state: WQTransitionState) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn) {
            self.config(presented, presenting: presenting, present: state)
        }
        return animator
    }
}

public typealias WQAnimatedConfigItems = [WQAnimatedConfigAble]

/// 动画属性配置 (主要配置参与动画的两个ccontroller的属性变化)
public class WQPresentedAnimatedItem<ViewControllerType, Element>: WQAnimatedConfigAble { 
    public typealias Value = Element
    public typealias Root = ReferenceWritableKeyPath<ViewControllerType, Value>
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
    public func config(_ presented: UIViewController?, presenting: UIViewController?, present state: WQTransitionState) {
        var configController: ViewControllerType?
        if let presentedVC = presented as? ViewControllerType {
            configController = presentedVC
        } else if let presentingVC = presenting as? ViewControllerType {
            configController = presentingVC
        }
        guard let controller = configController  else {
            return
        }
        switch state {
        case .initial:
            controller[keyPath: self.keyPath] = self.initial
        case .show:
            controller[keyPath: self.keyPath] = self.show
        case .dismiss:
            controller[keyPath: self.keyPath] = self.dismiss
        }
    }
}

/// 显示其他控制器的viewController的动画配置
public final class WQViewControllerAnimatedItem<Element>: WQPresentedAnimatedItem<UIViewController, Element> { }

/// 被present出来的viewController的动画配置
public final class WQAnimatedItem<Element>: WQPresentedAnimatedItem<WQPresentationable, Element> { }
public extension WQAnimatedItem where Element == UIColor? {
    class func defaultViewBackground(_ show: UIColor = UIColor.black.withAlphaComponent(0.6),
                                     initial: UIColor = UIColor.clear) -> WQAnimatedItem {
        let keyPath = \WQPresentationable.view.backgroundColor
        return WQAnimatedItem(keyPath, initial: initial, show: show)
    }
}
public extension WQAnimatedItem where Element == CGRect {
    
    /// VC view的背景动画 
    class func defaultViewShowFrame(_ show: CGRect = UIScreen.main.bounds,
                                    initial: CGRect = UIScreen.main.bounds) -> WQAnimatedItem {
        let keyPath = \WQPresentationable.view.frame
        return WQAnimatedItem(keyPath, initial: initial, show: show)
    }
    convenience init(container size: CGSize,
                     initial: WQPresentationOption.Position,
                     show: WQPresentationOption.Position,
                     dismiss: WQPresentationOption.Position? = nil,
                     presentedFrame: CGRect = UIScreen.main.bounds) {
        let initialFrame = initial.frame(size, presentedFrame: presentedFrame, isInside: false)
        let showFrame = show.frame(size, presentedFrame: presentedFrame, isInside: true)
        let dismissFrame = dismiss?.frame(size, presentedFrame: presentedFrame, isInside: false)
        self.init(containerFrame: initialFrame, show: showFrame, dismiss: dismissFrame)
    }
    convenience init(container position: CGPoint,
                     anchor point: CGPoint,
                     size: CGSize,
                     bounceStyle: WQPresentationOption.Bounce,
                     presentedFrame: CGRect = UIScreen.main.bounds) {
        let showFrame = CGRect(origin: position, size: size)
        let initialFrame = bounceStyle.estimateInitialFrame(position, anchorPoint: point, size: size, presentedFrame: presentedFrame)
        self.init(containerFrame: initialFrame, show: showFrame)
    }
    convenience init(container size: CGSize,
                     postionStyle: WQPresentationOption.Position,
                     bounceStyle: WQPresentationOption.Bounce,
                     presentedFrame: CGRect = UIScreen.main.bounds) {
        let postion = postionStyle.positionPoint(size, anchorPoint: CGPoint(x: 0.5, y: 0.5), viewFrame: presentedFrame)
        self.init(container: postion, anchor: CGPoint(x: 0.5, y: 0.5), size: size, bounceStyle: bounceStyle, presentedFrame: presentedFrame)
    }
    convenience init(containerFrame initial: CGRect, show: CGRect, dismiss: CGRect? = nil) {
        let keyPath = \WQPresentationable.containerView.frame
        self.init(keyPath, initial: initial, show: show, dismiss: dismiss ?? initial)
    }
}

public extension WQAnimatedItem where Element == CGAffineTransform {
    convenience init(containerTransform initial: CGAffineTransform, show: CGAffineTransform, dismiss: CGAffineTransform? = nil) {
        let keyPath = \WQPresentationable.containerView.transform
        self.init(keyPath, initial: initial, show: show, dismiss: dismiss ?? initial)
    }
}

public extension Array where Element == WQAnimatedConfigAble {
    
    func initial(_ presented: UIViewController?, presenting: UIViewController?) {
        self.setup(presented, presenting: presenting, state: .initial)
    }
    func config(_ presented: UIViewController?, presenting: UIViewController?, isShow: Bool) {
        self.setup(presented, presenting: presenting, state: isShow ? .show : .dismiss)
    }
    func setup(_ presented: UIViewController?, presenting: UIViewController?, state: WQTransitionState) {
        self.forEach { item in
            item.config(presented, presenting: presenting, present: state)
        }
    } 
    /// 创建一个包含 View frame 跟 view 默认Color 动画
    init(default item: WQAnimatedConfigAble, viewFrame: CGRect) {
        self.init()
        self.append(item)
        self.append(WQAnimatedItem.defaultViewBackground())
        self.append(WQAnimatedItem.defaultViewShowFrame(viewFrame, initial: viewFrame))
    }
}
