//
//  InteractDismissMode.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/27.
//

import Foundation

public enum PanDirection: Equatable {
    case toTop
    case toBottom
    case toLeft
    case toRight
}
public enum InteractDismissMode: Equatable {
    
    case none
    /// 点击容器以外的背景消失
    case tapOutSide
    /// 点击所有的背景都消失
    case tapAll
    /// 移动消失
    case pan(PanDirection)
}
extension PanDirection {
    var isHorizontal: Bool {
        return self == .toLeft || self == .toRight
    }
    /// 判断移动手势
    func isSameDirection(with velocity: CGPoint) -> Bool {
        switch self {
        case .toTop:
            return velocity.y > 0
        case .toBottom:
            return velocity.y < 0
        case .toLeft:
            return velocity.x > 0
        case .toRight:
            return velocity.x < 0
        }
    }
    /// 根据gesture 移动的point获取Value
    func translationOffset(with translation: CGPoint) -> CGFloat {
        switch self {
        case .toBottom:
            return  max(translation.y, 0)
        case .toLeft:
            return  max(-translation.x, 0)
        case .toRight:
            return  max(translation.x, 0)
        case .toTop:
            return  max(-translation.y, 0)
        }
    }
    
}
