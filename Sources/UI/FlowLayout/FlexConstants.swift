//
//  FlexConstants.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/5/10.
//

import Foundation
/// 属性决定主轴的方向（即项目的排列方向）
public enum FlexDirection {
    case row, rowReverse, column, columnReverse
}
///默认情况下，项目都排在一条线（又称"轴线"）上。flex-wrap属性定义，如果一条轴线排不下，如何换行。
public enum FlexWrap {
    case noWrap, wrap, wrapReverse
} 
/// 属性定义了项目在主轴上的对齐方式
public enum FlexJustify {
    case flexStart, flexEnd, center, spaceBetween, spaceAround
}
/// 属性定义项目在交叉轴上如何对齐
public enum FlexItem {
    case flexStart, flexEnd, center, baseline, stretch
}
/// 定义了多根轴线的对齐方式。如果项目只有一根轴线，该属性不起作用
public enum FlexContent {
    case flexStart, flexEnd, center, spaceBetween, spaceAround, stretch
}

/// 属性允许单个项目有与其他项目不一样的对齐方式，可覆盖align-items属性。默认值为auto 表示继承父元素的align-items属性，如果没有父元素，则等同于stretch
public enum FlexAlignItem {
    case auto,flexStart,flexEnd,center,baseline,stretch
}
