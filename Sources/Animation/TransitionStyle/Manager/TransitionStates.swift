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
public enum ModalState: Comparable {
    /// 准备显示之前状态
    case readyToShow
    /// 显示
    case show
    /// 准备隐藏
    case readyToHide
    ///
    case hide
}

//internal extension ModalState {
//    var isShow: Bool {
//        switch self {
//        case .show:
//            return true
//        default:
//            return false
//        }
//    }
//}

public enum HorizontalPanPosition {
    case center

    case top

    case bottom
}

public enum VerticalPanPosition {
    case center
    
    case leading
    
    case trailing
}
/// showing的时候 in
public struct PanPosition {
    let horizontal: HorizontalPanPosition
    let vertical: VerticalPanPosition
}
/// contentView的 最终显示方式
public enum TransitionShowStyle {
    /// 定点中间显示
    case alert
    /// 考虑是否默认添加底部safeArea间距色块
    case actionSheet
    /// 自定义显示
    case pan([ModalState: PanPosition])
    /// 自定义显示位置
    case custom([ModalState: WQReferenceStates])
} 
/// 支持动画方式
public enum TransitionAnimationStyle {
    /// 背景淡入
    case fade
    case scaleFade
    /// 自定义states 默认动画
    case custom(TransitionAnimation)
}

public extension TransitionAnimationStyle {
    
    var animator: TransitionAnimation {
        switch self {
        case .fade:
            return ModalFadeAnimation()
        case .scaleFade:
            return ModalScaleFadeAnimation()
        case let .custom(animation):
            return animation
        }
    }
}
