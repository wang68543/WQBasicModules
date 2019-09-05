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
    case auto // 没有动画不做任何处理
    /// 使用自定义的 转场动画
    case customModal
    /// 直接添加到父控制器上
    case child
    /// 创建新窗口并且成为新窗口的根控制器
    case newWindowRoot
}
extension UIView {
    
}

fileprivate var transitionManagerKey: Void?
extension UIViewController {
    var transition: TransitionManager {
        set {
            objc_setAssociatedObject(self, &transitionManagerKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return (objc_getAssociatedObject(self, &transitionManagerKey) as? TransitionManager) ?? TransitionManager(self)
        }
    }
}
open class TransitionManager: NSObject {
    /// interaction progress
//    public internal(set) var fractionComplete: CGFloat = 0.0
    public typealias Completion = (() -> Void)
    public weak var delegate: TransitionManagerDelegate?
    /// 当前是否正在 显示
    public internal(set) var isShow: Bool = true
    /// 是否需要管理VC的生命周期
    public var shouldViewControllerLifeCycle: Bool = false
    /// 是否正在交互
    public var isInteractive: Bool = false
    
    /// 动画时长
    public var duration: TimeInterval = 0.25
    
    weak var fromViewController: UIViewController?
//    weak var toViewController: UIViewController?
    public internal(set) var containerWindow: WQTransitionWindow?
    
    var transitionStyle: TransitionStyle = .auto
    public unowned let showViewController: UIViewController
    init(_ viewController: UIViewController) {
        self.showViewController = viewController
        super.init()
    }
     
    func show(in viewController: UIViewController, animated flag: Bool, completion: Completion?) {
        self.fromViewController = viewController
       
    }
    func present(by viewController: UIViewController?, animated flag: Bool, completion: Completion?) {
        self.fromViewController = viewController ?? UIApplication.shared.delegate?.window??.rootViewController
        self.transitionStyle = .customModal
        self.showViewController.modalPresentationStyle = .custom
        self.fromViewController?.transitioningDelegate = self
        self.showViewController.modalPresentationStyle = .custom
        self.showViewController.transitioningDelegate = self
        self.fromViewController?.present(self.showViewController, animated: flag, completion: completion)
    }
    /// 默认为一个全屏的透明的window
    func show(with window: WQTransitionWindow? = nil) {
        self.containerWindow = window ?? WQTransitionWindow(frame: UIScreen.main.bounds)
        
    }
    
//    @available(iOS 10.0, *)
//    var propertyAnimator: UIViewPropertyAnimator?
    
//    public weak var fromViewController: UIViewController?
//    public weak var toViewController: UIViewController?
    
}
