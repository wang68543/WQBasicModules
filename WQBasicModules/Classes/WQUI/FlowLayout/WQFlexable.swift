//
//  WQFlexable.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/11/17.

import UIKit

//notaTODO:整个布局都是以Section为单位进行的 整个section的布局还是按照原有的
// MARK: - ==========整个View的属性===============

///属性决定主轴的方向（即项目的排列方向）
@objc
public enum WQFlexDirection: Int {
    
    /// （默认值）：主轴为水平方向，起点在左端。
    case row
    
    /// 主轴为水平方向，起点在右端。
    case rowReverse
    
    /// 主轴为垂直方向，起点在上沿。
    case column
    
    /// 主轴为垂直方向，起点在下沿。
    case columnReverse
}
public extension WQFlexDirection {
    
    /// 是否是水平方向
    var isHorizontal: Bool {
        return self == .row || self == .rowReverse
    }
    var isReverse: Bool {
        return self == .columnReverse || self == .rowReverse
    }
}
/// 属性定义了项目在主轴上的对齐方式。(布局去掉了ectionInset区域)
@objc
public enum WQJustifyContent: Int {
    
    /// （默认值）：左对齐
    case flexStart
    
    /// 右对齐
    case flexEnd
    
    /// 居中
    case center
    
    /// 两端对齐，项目之间的间隔都相等。
    case spaceBetween
    
    /// 每个项目两侧的间隔相等。所以，项目之间的间隔比项目与边框的间隔大一倍。
    case spaceAround
}
//定义项目在交叉轴上如何对齐。
@objc
public enum WQAlignItems: Int {
    
    /// 交叉轴的起点对齐。
    case flexStart
    
    /// 交叉轴的终点对齐。
    case flexEnd
    
    /// 交叉轴的中点对齐。
    case center
    
    //    /// 项目的第一行文字的基线对齐。
    //    case baseline
    
    /// （默认值）：如果项目未设置高度或设为auto，将占满整个容器的高度。
    case stretch
}
extension WQAlignItems {
    /// 如果是isReverse origin就是从cell的尾部开始的
    func fixItemFrame(_ origin: CGPoint,
                      size: CGSize,
                      lineMaxWidth: CGFloat,
                      isHorizontal: Bool,
                      isReverse: Bool) -> CGRect {
        var frame = CGRect(origin: origin, size: size)
        if isHorizontal {
            switch self {
            case .center:
                frame.origin.y += (lineMaxWidth - size.height) * 0.5
            case .flexEnd:
                frame.origin.y += lineMaxWidth - size.height
            case .stretch:
                frame.size.height = lineMaxWidth
            default:
                break
            }
            if isReverse {
                frame.origin.x = frame.minX - size.width
            }
        } else {
            switch self {
            case .center:
                frame.origin.x += (lineMaxWidth - size.width) * 0.5
            case .flexEnd:
                frame.origin.x += lineMaxWidth - size.width
            case .stretch:
                frame.size.width = lineMaxWidth
            default:
                break
            }
            if isReverse {
                frame.origin.y = frame.minY - size.height
            }
        }
        return frame
    }
}
// 适应行间距 以line为单位布局每个Section
@objc
public enum WQAlignContent: Int {
    /// 交叉轴的起点对齐。
    case flexStart

    /// 交叉轴的终点对齐。
    case flexEnd

    /// 交叉轴的中点对齐。
    case center

    /// 与交叉轴两端对齐，轴线之间的间隔平均分布。
    case spaceBetween

    /// 每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍。
    case spaceAround

    /// （默认值）：轴线占满整个交叉轴。
    //    case stretch
}
// MARK: - ==========整个View的属性END===============
//// MARK: - ==========Cell属性==========
//@objc public enum WQAlignSelf: Int {
//    case auto //继承自父View的属性
//    /// 交叉轴的起点对齐。
//    case flexStart
//
//    /// 交叉轴的终点对齐。
//    case flexEnd
//
//    /// 交叉轴的中点对齐。
//    case center
//
//    /// 项目的第一行文字的基线对齐。
//    case baseline
//
//    /// （默认值）：如果项目未设置高度或设为auto，将占满整个容器的高度。
//    case stretch
//}
//// MARK: - ==========Cell属性END==========
