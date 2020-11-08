//
//  ModalContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit 

open class ModalContext: NSObject, WQLayoutControllerTransition {
    public func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
         
    }
    
//    public func didViewLoad(_ controller: WQLayoutController) {
//
//    }
    
//    public func show(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) {
//
//    }
    
    public func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
         return true
    }
    
     
    public let animator: TransitionAnimation
    
    public unowned let config: ModalConfig
    
    public let statesConfig: StyleConfig
    
//    public unowned let showViewController: WQLayoutController
    
    public init(_ config: ModalConfig, states: StyleConfig) {
        self.config = config
        self.statesConfig = states
//        self.showViewController = layoutController
        animator = states.animator
        super.init()
    }
//    public unowned let showViewController: WQLayoutController
    
//    public weak var fromViewController: UIViewController?
    
//    public let style: ModalStyle
    /// 动画时长
//    open var duration: TimeInterval = 0.25
    /// 动画结束的时候的View的状态
//    open var modalState: ModalState = .readyToShow
    /// 是否能够交互
//    open var isInteractable: Bool = false
    /// 是否正在交互
//    open var isInteracting: Bool = false
    /// 如果使用Spring动画 就禁止交互动画
//    open var isSpring: Bool = false
    /// 转场动画承载View
//    public private(set) weak var transitioningContainerView: UIView?
    
    /// 初始化转场场景
    /// - Parameters:
    ///   - viewController: 用于承载弹窗的ViewController
    ///   - fromViewController: 当前动画场景的起始
//    public init(_ viewController: WQLayoutController, style: ModalStyle) {
//        self.showViewController = viewController
//        self.style = style
//        super.init()
//    }
//
//    open func dismiss(animated flag: Bool, completion: Completion? = nil) {
//         
//    }
//    
//    open func show(in viewController: UIViewController?, animated flag: Bool, completion: Completion? = nil) {
//        self.fromViewController = viewController
//    }
//    
//    /// 在开始显示动画之前 提前准备一些动作
//    open func prepareShow() {
//        
//    }
//    
//    /// 显示动画
//    /// - Parameter completion: 动画完成回调
//    open func showAnimation(_ completion: Completion) {
//        
//    }
//    /// 在开始隐藏动画之前 提前准备一些动作
//    open func prepareHide() {
//        
//    }
//    /// 隐藏动画
//    /// - Parameter completion: 动画完成
//    open func hideAnimation(_ completion: Completion) {
//        
//    } 
    
}

/// 主要用于驱动动画 含驱动管理
open class ModalDrivenContext: ModalContext {
    
}

public extension ModalContext {
    /// 添加属性到fromViewController
    func addStateFromTarget(_ values: [TSReferenceWriteable], state: ModalState) {
        guard let from = self.config.fromViewController else { return }
        self.statesConfig.addState(from, values: values, state: state)
    }
    /// 添加属性到fromViewController
    func addStateFromTarget(_ value: TSReferenceWriteable, state: ModalState) {
        self.addStateFromTarget([value], state: state)
    }
    /// 添加属性到presenting
    func addStateToTarget(_ values: [TSReferenceWriteable], state: ModalState) {
//        self.statesConfig.addState(showViewController, values: values, state: state)
    }
    /// 添加属性到presenting
    func addStateToTarget(_ value: TSReferenceWriteable, state: ModalState) {
        self.addStateToTarget([value], state: state)
    }
}
/// 构造不同的动画场景
public extension ModalContext {
    static func modalContext(_ config: ModalConfig, states: StyleConfig) -> ModalContext? {
        
        func context(_ style: ModalStyle) -> ModalContext? {
            switch style {
            case .modalSystem:
                return ModalPresentationContext(config, states: states)
            case .modalInParent:
                return ModalInParentContext(config, states: states)
            case .modalInWindow:
                return ModalInWindowContext(config, states: states)
            case .modalPresentWithNavRoot:
                return ModalPresentWithNavRootContext(config, states: states)
            default:
                return nil
            }
        }
        switch config.style {
        case .autoModal:
            return context(config.style.autoAdaptationStyle)
        default:
            return context(config.style)
        }
    }
}
