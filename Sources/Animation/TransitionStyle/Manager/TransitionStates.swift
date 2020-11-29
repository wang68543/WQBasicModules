//
//  TransitionStates.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import Foundation
import UIKit

public enum ModalPresentation: Equatable {
    case modalSystem(UIViewController?)
    /// 这里要分
    case modalInParent(UIViewController)
    case modalInWindow
    /// 以Nav rootViewController的形式present
    case modalPresentWithNavRoot(UINavigationController)
    /// 根据当前场景自动选择 (优先system 其次parent 再window)
    case autoModal
}
 
public extension ModalPresentation {
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
    var autoAdaptationStyle: ModalPresentation {
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
public enum ModalState: Int, Equatable, CaseIterable {
    /// 准备显示之前状态
    case willShow
    /// 显示
    case show
    case didShow
//    /// 准备隐藏
    case willHide
    ///
    case hide
//    case didHide
}
public extension ModalState {
    var preNode: ModalState? {
        return ModalState(rawValue: self.rawValue-1)
    }
    var nextNode: ModalState? {
        return ModalState(rawValue: self.rawValue+1)
    }
    var isOutSide: Bool {
        switch self {
        case .show, .didShow, .willHide:
            return false
        default:
            return true
        }
    }
}

public enum HorizontalPanPosition {
    case center, leading, trailing
}
public enum VerticalPanPosition {
    case center, top, bottom
}

/// contentView的 最终显示方式
public enum ModalShowStyle {
   /// 定点中间显示
   case alert
   /// 考虑是否默认添加底部safeArea间距色块
   case actionSheet
   /// 自定义显示
   case pan([ModalState: PanPosition])
   /// 自定义显示位置
   case custom([ModalState: ModalMapItems])
}

/// 支持动画方式
@available(iOS 10.0, *)
public enum ModalAnimationStyle {
   /// 背景淡入
   case `default`
//   case scaleFade
   /// 自定义states 默认动画
   case custom(ModalAnimation)
}
/// showing的时候 in
public struct PanPosition {
    let horizontal: HorizontalPanPosition
    let vertical: VerticalPanPosition
}
public extension PanPosition {
    func frame(size: CGSize, container: CGSize, state: ModalState) -> CGRect {
        var origin: CGPoint = .zero
        let isOutSide = state.isOutSide
        switch horizontal {
        case .leading:
            if isOutSide {
                origin.x = -size.width
            } else {
                origin.x = 0
            }
        case .center:
            origin.x = (container.width - size.width) * 0.5;
        case .trailing:
            if isOutSide {
                origin.x = container.width
            } else {
                origin.x = container.width - size.width
            }
        }
        switch vertical {
        case .top:
            if isOutSide {
                origin.y = -size.height
            } else {
                origin.y = 0
            }
        case .center:
            origin.y = (container.height - size.height) * 0.5
        case .bottom:
            if isOutSide {
                origin.y = container.height
            } else {
                origin.y = container.height - size.height
            }
        }
        return CGRect(origin: origin, size: size)
    }
    func center(size: CGSize, container: CGSize, state: ModalState) -> CGPoint {
        var centerX: CGFloat = .zero
        var centerY: CGFloat = .zero
        let isOutSide = state.isOutSide
        switch horizontal {
        case .leading:
            if isOutSide {
                centerX = -size.width*0.5
            } else {
                centerX = size.width*0.5
            }
        case .center:
            centerX = container.width * 0.5;
        case .trailing:
            if isOutSide {
                centerX = container.width + size.width * 0.5
            } else {
                centerX = container.width - size.width * 0.5
            }
        }
        switch vertical {
        case .top:
            if isOutSide {
                centerY = -size.height*0.5
            } else {
                centerY = size.height*0.5
            }
        case .center:
            centerY = container.height * 0.5
        case .bottom:
            if isOutSide {
                centerY = container.height + size.height * 0.5
            } else {
                centerY = container.height - size.height * 0.5
            }
        }
        return CGPoint(x: centerX, y: centerY)
    }
}
public extension PanPosition {
    static func bottomToCenter(_ autoReverse: Bool) -> [ModalState: PanPosition] {
        var states: [ModalState: PanPosition] = [:]
        states[.willShow] = PanPosition(horizontal: .center, vertical: .bottom)
        states[.show] = PanPosition(horizontal: .center, vertical: .center)
        if autoReverse {
            states[.hide] = states[.willShow]
        } else {
            states[.hide] = PanPosition(horizontal: .center, vertical: .top)
        }
        return states
    }
    static func topToCenter(_ autoReverse: Bool) -> [ModalState: PanPosition] {
        var states: [ModalState: PanPosition] = [:]
        states[.willShow] = PanPosition(horizontal: .center, vertical: .top)
        states[.show] = PanPosition(horizontal: .center, vertical: .center)
        if autoReverse {
            states[.hide] = states[.willShow]
        } else {
            states[.hide] = PanPosition(horizontal: .center, vertical: .bottom)
        }
        return states
    }
}
@available(iOS 10.0, *)
public extension ModalAnimationStyle {
    
    var animator: ModalAnimation {
        switch self {
        case .default:
            return ModalDefaultAnimation()
//        case .scaleFade:
//            return ModalScaleFadeAnimation()
        case let .custom(animation):
            return animation
        }
    }
}
