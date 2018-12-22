//
//  WQFlexable.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/11/17.
//  swiftlint:disable line_length

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

@objc
public protocol WQFlexboxDelegateLayout: UICollectionViewDelegateFlowLayout {
    
    /// 返回每个Section的高度;当只有一个section的时候 高度默认为collectionView的height
    /// section尺寸 (包含header、footer(上下布局) 包含sectionInsets)
    @objc
    optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, sizeForSectionAt section: Int) -> CGSize
    //    @objc optional func flexbox(_ flexbox: WQFlexbox, alignItemAt indexPath: IndexPath) -> WQAlignSelf
    /// Cells排列方向
    @objc
    optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, directionForSectionAt section: Int) -> WQFlexDirection
    @objc
    optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, justifyContentForSectionAt section: Int, inLine lineNum: Int, linesCount: Int) -> WQJustifyContent
    @objc
    optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, alignItemsForSectionAt section: Int, inLine lineIndex: Int, with indexPath: IndexPath) -> WQAlignItems
    @objc
    optional func flexbox(_ collectionView: UICollectionView, flexbox: WQFlexbox, alignContentForSectionAt section: Int) -> WQAlignContent
}

internal struct LinesFrameAttribute {
    
    let direction: WQFlexDirection
    /// 当前分区的左上角 主要记录用于后续计算 (包含insets和header、footer的高度)
    var rect: CGRect = .zero
    
    var insets: UIEdgeInsets = .zero
    
    var headerSize: CGSize = .zero
    
    var footerSize: CGSize = .zero
    
    /// 分区号
    let section: Int
    /// 每个line中item的最大边框集合 (例:当direction水平的时候这里表示每个line中item的最大高度集合)
    let maxValues: [CGFloat]
    
    /// 每个line常规边框的总和 (例:当direction水平的时候这里表示每个line中每个item宽度和的集合)
    let totalValues: [CGFloat]
    
    /// 所有line的最大边框的和 (例:当direction水平的时候这里表示每个line中line中item的最大高度和)
    let sumMaxValue: CGFloat
    
    /// section中lines数量
    let count: Int
    
    init(_ section: Int, maxValues: [CGFloat], totalValues: [CGFloat], sumMaxValue: CGFloat, direction: WQFlexDirection) {
        self.section = section
        self.maxValues = maxValues
        self.totalValues = totalValues
        self.sumMaxValue = sumMaxValue
        self.count = maxValues.count
        self.direction = direction
    }
}
extension LinesFrameAttribute {
    var limitMaxLength: CGFloat {
        if self.direction.isHorizontal {
            return rect.width - insets.left - insets.right
        } else {
            return rect.height - insets.top - insets.bottom
        }
    }
    var contentSize: CGSize {
        return CGSize(width: rect.width - insets.left - insets.right, height: rect.height - insets.top - insets.bottom)
    }
}
internal struct LinesMarginAttribute {
    /// 起始部分的边距
    let margin: CGFloat
    /// 剩余的边距
    let remainingMargin: CGFloat
    /// line的间距 
    let space: CGFloat
   
    let section: Int
}

internal struct LineItemsMarginAttribute {
    /// line的主轴方向坐标起始值(参照当前Section的原点)
    let startItemValue: CGFloat 
    /// item间隔
    let itemSpace: CGFloat
    /// 当前行items的数量
    let count: Int
     //第几分区第几行
    let section: Int
    let index: Int
    //实际的内容大小
//    let realSize: CGSize
}
