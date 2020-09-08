//
//  TransitionStates.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import Foundation


public enum ModalStyle {
    case modalSystem
    /// 这里要分
    case modalInParent
    case modalInWindow
    /// 以Nav rootViewController的形式present
    case modalPresentWithNavRoot
    /// 根据当前场景自动选择 (优先system 其次parent 再window)
    case autoModal
}

/**
 1.封装动画参数 根据不同参数进行不同的动画
 2.封装动画属性变化 alert sheet(转换为custom对应的属性) custom
 3.支持present, showInParent, navRootViewcontroller present(用于解决半透明跳转问题)
 4.可额外安排显示队列 (加唯一标识)
 */

/// 处理bottom
/// 转场的状态
public enum ModalState {
    /// 准备显示之前状态
    case readyToShow
    /// 显示
    case showing
    ///
    case hide
}

internal extension ModalState {
    var isShow: Bool {
        switch self {
        case .showing:
            return true
        default:
            return false
        }
    }
} 

/// 需扩展依赖于父控件的尺寸
public enum TransitionPosition {
    case none
    case centerZoom(Bool)
    case left(Bool)
    case right(Bool)
    case bottom(Bool)
    case top(Bool)
}
public enum TransitionShowStyle {
    case alert
    /// 考虑是否默认添加底部safeArea间距色块
    case actionSheet // 使用(alert) bottomOut bottomIn
    case custom
} 

