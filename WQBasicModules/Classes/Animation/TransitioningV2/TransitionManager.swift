//
//  TransitionManager.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/2.
//  swiftlint:disable line_length

import Foundation
public protocol TransitionManagerDelegate: NSObjectProtocol {
    func transitionManager(prepare manager: TransitionManager)
    /// 手势交互弹出
    func transitionManager(shouldShowController manager: TransitionManager) -> UIViewController
    
    func transitionManager(willTransition manager: TransitionManager, fromViewController: UIViewController?, toViewController: UIViewController?)
    
}
public enum TransitionStyle {
//    case none //使用系统自带的 动画方式
    /// 使用自定义的 转场动画
    case customModal
    /// 直接添加到父控制器上
    case child
    /// 创建新窗口并且成为新窗口的根控制器
    case newWindowRoot
}

open class TransitionManager: NSObject {
    /// interaction progress
//    public internal(set) var fractionComplete: CGFloat = 0.0
    public weak var delegate: TransitionManagerDelegate?
    /// 当前是否正在 显示
    public internal(set) var isShow: Bool = true
    /// 是否需要管理VC的生命周期
    public var shouldViewControllerLifeCycle: Bool = false
    /// 是否正在交互
    public var isInteractive: Bool = false
    
    /// 转场上下文 
    var transitionContext: UIViewControllerContextTransitioning?
    
//    @available(iOS 10.0, *)
//    var propertyAnimator: UIViewPropertyAnimator?
    
//    public weak var fromViewController: UIViewController?
//    public weak var toViewController: UIViewController?
    
}
