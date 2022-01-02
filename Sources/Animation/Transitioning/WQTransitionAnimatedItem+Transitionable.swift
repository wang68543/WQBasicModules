//
//  WQTransitionAnimatedItem+Transitionable.swift
//  Pods
//
//  Created by WQ on 2019/12/31.
//

import Foundation
/// 被present出来的viewController的动画配置
public final class WQAnimatedItem<Element>: WQTransitionAnimatedItem<WQTransitionable, Element> { }
public extension WQAnimatedItem where Element == UIColor? {
    class func defaultViewBackground(_ show: UIColor = UIColor.black.withAlphaComponent(0.6),
                                     initial: UIColor = UIColor.clear) -> WQAnimatedItem {
        let keyPath = \WQTransitionable.view.backgroundColor
        return WQAnimatedItem(keyPath, initial: initial, show: show)
    }
}
public extension WQAnimatedItem where Element == CGRect {

    /// VC view的背景动画
    class func defaultViewShowFrame(_ show: CGRect = UIScreen.main.bounds,
                                    initial: CGRect = UIScreen.main.bounds) -> WQAnimatedItem {
        let keyPath = \WQTransitionable.view.frame
        return WQAnimatedItem(keyPath, initial: initial, show: show)
    }
    convenience init(container size: CGSize,
                     initial: WQTransitionOption.Position,
                     show: WQTransitionOption.Position,
                     dismiss: WQTransitionOption.Position? = nil,
                     presentedFrame: CGRect = UIScreen.main.bounds) {
        let initialFrame = initial.frame(size, presentedFrame: presentedFrame, isInside: false)
        let showFrame = show.frame(size, presentedFrame: presentedFrame, isInside: true)
        let dismissFrame = dismiss?.frame(size, presentedFrame: presentedFrame, isInside: false)
        self.init(containerFrame: initialFrame, show: showFrame, dismiss: dismissFrame)
    }
    convenience init(container position: CGPoint,
                     anchor point: CGPoint,
                     size: CGSize,
                     bounceStyle: WQTransitionOption.Bounce,
                     presentedFrame: CGRect = UIScreen.main.bounds) {
        let origin = CGPoint(x: position.x + point.x * size.width, y: position.y + point.y * size.height)
        let showFrame = CGRect(origin: position, size: size)
        let initialFrame = bounceStyle.estimateInitialFrame(origin, anchorPoint: point, size: size, presentedFrame: presentedFrame)
        self.init(containerFrame: initialFrame, show: showFrame)
    }
    convenience init(container size: CGSize,
                     postionStyle: WQTransitionOption.Position,
                     bounceStyle: WQTransitionOption.Bounce,
                     presentedFrame: CGRect = UIScreen.main.bounds) {
        let anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let postion = postionStyle.positionPoint(size, anchorPoint: anchorPoint, viewFrame: presentedFrame)
        self.init(container: postion, anchor: anchorPoint, size: size, bounceStyle: bounceStyle, presentedFrame: presentedFrame)
    }
    convenience init(containerFrame initial: CGRect, show: CGRect, dismiss: CGRect? = nil) {
        let keyPath = \WQTransitionable.containerView.frame
        self.init(keyPath, initial: initial, show: show, dismiss: dismiss ?? initial)
    }
}

public extension WQAnimatedItem where Element == CGAffineTransform {
    convenience init(containerTransform initial: CGAffineTransform, show: CGAffineTransform, dismiss: CGAffineTransform? = nil) {
        let keyPath = \WQTransitionable.containerView.transform
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
            if item.isPresentingConfig {
                if let viewController = presenting {
                   item.config(viewController, present: state)
                }
            } else {
                if let viewController = presented {
                   item.config(viewController, present: state)
                }
            }
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
