//
//  ModalContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit


open class ModalContext: NSObject {
    
    public typealias Completion = (() -> Void)
    
    public var readyShowStates: [AnyHashable: [TSReferenceWriteable]] = [:]
    public var showingStates: [AnyHashable: [TSReferenceWriteable]] = [:]
    public var dismissStates: [AnyHashable: [TSReferenceWriteable]] = [:]
     /// 这里的view 咋 readShow的时候 添加到view showing的时候移除 (主要用于开场显示的时候 从一个动画到这个动画)
    public var snapShotShowViews: [UIView] = []
    /// showing -> hide的时候 显示
    public var snapShotHideViews: [UIView] = []
    
    
    public unowned let showViewController: WQLayoutController
    
    public weak var fromViewController: UIViewController?
    /// 动画时长
    open var duration: TimeInterval = 0.25
    /// 动画结束的时候的View的状态
    open var modalState: ModalState = .readyToShow
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
    public init(_ viewController: WQLayoutController) {
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
    static func modalContext(with viewController: WQLayoutController, modalStyle: ModalStyle) -> ModalContext? {
        switch modalStyle {
        case .modalSystem:
            return ModalPresentationContext(viewController)
        case .modalInParent:
            return ModalInParentContext(viewController)
        case .modalInWindow:
            return ModalInWindowContext(viewController)
        case .modalPresentWithNavRoot:
            return ModalPresentWithNavRootContext(viewController)
        case .autoModal:
            return nil
        }
    }
}
