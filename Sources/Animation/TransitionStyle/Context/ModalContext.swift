//
//  ModalContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit 

open class ModalContext: NSObject, WQLayoutControllerTransition {
    
    public let animator: ModalAnimation
    
    public unowned let config: ModalConfig
    
    public let styleConfig: StyleConfig
    
    public init(_ config: ModalConfig, states: StyleConfig) {
        self.config = config
        self.styleConfig = states
        animator = states.animator
        super.init()
    }
    public func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
         
    }
    public func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
         return true
    }
    
    deinit {
       debugPrint("\(self):" + #function + "♻️")
    }
}

/// 主要用于驱动动画 含驱动管理
open class ModalDrivenContext: ModalContext {
    
}
/// 构造不同的动画场景
public extension ModalContext {
    static func modalContext(_ config: ModalConfig, states: StyleConfig) -> ModalContext? {
        let fixStyle: ModalPresentation
        if config.style == .autoModal {
            fixStyle = config.style.autoAdaptationStyle
        } else {
            fixStyle = config.style
        }
        switch fixStyle {
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
}
