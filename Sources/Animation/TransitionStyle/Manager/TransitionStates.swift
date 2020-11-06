//
//  TransitionStates.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import Foundation
import UIKit

public enum ModalStyle {
    case modalSystem(UIViewController?)
    /// 这里要分
    case modalInParent(UIViewController)
    case modalInWindow
    /// 以Nav rootViewController的形式present
    case modalPresentWithNavRoot(UINavigationController)
    /// 根据当前场景自动选择 (优先system 其次parent 再window)
    case autoModal
}

public extension ModalStyle {
    ///
    var fromViewController: UIViewController? {
        switch self {
        case let .modalSystem(viewController):
            return viewController ?? WQUIHelp.topVisibleViewController()
        case let .modalInParent(viewController):
            return viewController
        case let .modalPresentWithNavRoot(navgationController):
            return navgationController
        case .autoModal:
            return self.autoAdaptationStyle.fromViewController
        default:
            return nil
        }
    }
    /// 自动适配autoModal Style
    var autoAdaptationStyle: ModalStyle {
        switch self {
        case .autoModal:
            if let topVisible = WQUIHelp.topVisibleViewController() {
                if topVisible.presentedViewController == nil {
                    return .modalSystem(topVisible)
                } else {
                    return .modalInParent(topVisible)
                }
            } else {
                return .modalInWindow
            }
        default:
            return self
        }
    }
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
    case willShow
    /// 显示
    case show
    case didShow
//    /// 准备隐藏
    case willHide
    ///
    case hide
    case didHide
} 

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
