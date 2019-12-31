//
//  WQTransitionAnimatedItem.swift
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
    /// 是否是针对正在显示ViewController
//    var isPresentingConfig: Bool { get }
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
public class WQTransitionAnimatedItem<ViewControllerType, Element>: WQAnimatedConfigAble { 
    public typealias Value = Element
    public typealias Root = ReferenceWritableKeyPath<ViewControllerType, Value>
    public let keyPath: Root
    public var initial: Value
    public var show: Value
    public var dismiss: Value
//    public let isPresentingConfig: Bool
    public init(_ key: Root, initial: Value, show: Value, dismiss: Value? = nil) { //, isPresenting: Bool = true
        self.keyPath = key
        self.initial = initial
        self.dismiss = dismiss ?? initial
        self.show = show
//        self.isPresentingConfig = isPresenting
    }
    public func config(_ presented: UIViewController?, presenting: UIViewController?, present state: WQTransitionState) {
        var configController: ViewControllerType?
//        if let presentedVC = presented as? ViewControllerType {
//            configController = presentedVC
//        } else
            if let presentingVC = presenting as? ViewControllerType {
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
public final class WQViewControllerAnimatedItem<Element>: WQTransitionAnimatedItem<UIViewController, Element> { }
