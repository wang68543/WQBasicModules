//
//  ModalShowStyle.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/12/18.
//

import Foundation
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
public enum PopDirection {
    case left, right, up, down, horizontalMiddle, verticalMiddle, horizontalAuto, verticalAuto
}
public enum PopAlignment {
    case leading, middle, trailing
}
/// contentView的 最终显示方式
public enum ModalShowStyle {
   /// 定点中间显示
   case alert
   /// 考虑是否默认添加底部safeArea间距色块 pan的子集
   case actionSheet
   /// 自定义显示
   case pan([ModalState: PanPosition])
   /// 弹出 point1: postion  point2: anchorPoint(弹出框与锚点结合的位置范围0~1)
   case popup(CGPoint, CGPoint, PopDirection)
   /// 自定义显示位置
   case custom([ModalState: ModalMapItems])
}
 
//public extension ModalShowStyle {
//    func frame(_ size: CGSize, container: CGSize, state: ModalState) -> CGRect {
//        switch self {
//        case let .popup(position, anchorPoint, isHorizontalExpend):
//            var origin: CGPoint = .zero
//            origin.x = position.x - anchorPoint.x * size.width
//            origin.y = position.y - anchorPoint.y * size.height
//           
//            return CGRect(origin: origin, size: size)
//        default:
//            //TODO: - 待实现
//            break
//        }
//        return .zero
//    }
//} 
public enum PanHorizontal {
    case center, leading, trailing
}
public enum PanVertical {
    case center, top, bottom
}
/// showing的时候 in
public struct PanPosition {
    public let horizontal: PanHorizontal
    public let vertical: PanVertical
    init(_ horizontal: PanHorizontal, vertical: PanVertical) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
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
    
    static func fromLeftIn(_ autoReverse: Bool) -> [ModalState: PanPosition] {
        var states: [ModalState: PanPosition] = [:]
        states[.willShow] = PanPosition(.leading, vertical: .center)
        states[.show] = PanPosition(.leading, vertical: .center)
        if autoReverse {
            states[.hide] = states[.willShow]
        } else {
            states[.hide] = PanPosition(.leading, vertical: .center)
        }
        return states
    }
    static func bottomToCenter(_ autoReverse: Bool) -> [ModalState: PanPosition] {
        var states: [ModalState: PanPosition] = [:]
        states[.willShow] = PanPosition(.center, vertical: .bottom)
        states[.show] = PanPosition(.center, vertical: .center)
        if autoReverse {
            states[.hide] = states[.willShow]
        } else {
            states[.hide] = PanPosition(.center, vertical: .top)
        }
        return states
    }
    static func topToCenter(_ autoReverse: Bool) -> [ModalState: PanPosition] {
        var states: [ModalState: PanPosition] = [:]
        states[.willShow] = PanPosition(.center, vertical: .top)
        states[.show] = PanPosition(.center, vertical: .center)
        if autoReverse {
            states[.hide] = states[.willShow]
        } else {
            states[.hide] = PanPosition(.center, vertical: .bottom)
        }
        return states
    }
}
