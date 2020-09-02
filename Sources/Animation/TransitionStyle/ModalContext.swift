//
//  ModalContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit

public enum ModalStyle {
    case modalSystem
    /// 这里要分
    case modalInParent
    case modalInWindow
    /// 根据当前场景自动选择
    case autoModal
    
}
open class ModalContext: NSObject {
    
    public typealias Completion = (() -> Void)
    
    public unowned let showViewController: WQLayoutContainerViewController
    
    public weak var fromViewController: UIViewController?
    /// 动画时长
    open var duration: TimeInterval = 0.25
    /// 动画结束的时候的View的状态
    open var modalState: ShowState = .readyToShow
    /// 是否能够交互
    open var isInteractiveable: Bool = false
    /// 是否正在交互
    open var isInteracting: Bool = false
    
    /// 如果使用Spring动画 就禁止交互动画
    open var isSpring: Bool = false
    
    /// 初始化转场场景
    /// - Parameters:
    ///   - viewController: 用于承载弹窗的ViewController
    ///   - fromViewController: 当前动画场景的起始
    public init(_ viewController: WQLayoutContainerViewController) {
        self.showViewController = viewController
        super.init()
    }
    
    open func dismiss(animated flag: Bool, completion: Completion? = nil) {
        
    }
    
    open func show(in viewController: UIViewController?, animated flag: Bool, completion: Completion? = nil) {
        self.fromViewController = viewController
    }
     
    
}

/// 主要用于驱动动画 含驱动管理
open class ModalDrivenContext: ModalContext {
    
}

/// 构造不同的动画场景
public extension ModalContext {
    static func modalContext(with viewController: WQLayoutContainerViewController, modalStyle: ModalStyle) -> ModalContext? {
        switch modalStyle {
        case .modalSystem:
            return ModalPresentationContext(viewController)
        case .modalInParent:
            return ModalInParentContext(viewController)
        case .modalInWindow:
            return ModalInWindowContext(viewController)
        case .autoModal:
            return nil
        }
    }
}
