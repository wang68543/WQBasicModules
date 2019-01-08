//
//  WQPresentionStyle.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/16.
//

import Foundation
public class WQPresentionStyle {
    public enum Position {
        case none
        case left
        case top
        case right
        case bottom
        case center
    }
    /// 锚点定位动画
    public enum Bounce {
        case bounceCenter // 从0开始从中间弹开
        case verticalMiddle //横向摊开
        case horizontalMiddle //纵向摊开
        case verticalAuto // 基于position 自动计算剩余空间 哪边够显示哪边 默认向右
        case horizontalAuto // 基于position 默认向下
        case bounceUp //向上弹
        case bounceLeft // 左
        case bounceRight // 右
        case bounceDown // 向下弹 
    }
}
public extension WQPresentionStyle.Position {
    /// 根据TransitionType计算尺寸
    ///
    /// - Parameters:
    ///   - size: 中间View的尺寸
    ///   - type: TransitionType
    ///   - presentedFrame: 控制器的frame
    ///   - isInside: 计算的frame是否是在View内 (除了显示的时候在View内部 其余都在外部)
    /// - Returns: 计算好的frame
    func frame(_ size: CGSize, presentedFrame: CGRect, isInside: Bool = true) -> CGRect {
        var origin: CGPoint
        let viewW = presentedFrame.width
        let viewH = presentedFrame.height
        switch self {
        case .none:
            origin = .zero
        case .top:
            origin = CGPoint(x: (viewW - size.width) * 0.5, y: isInside ? 0 : -size.height)
        case .left:
            origin = CGPoint(x: isInside ? 0 : -size.width, y: (viewH - size.height) * 0.5)
        case .bottom:
            origin = CGPoint(x: (viewW - size.width) * 0.5, y: isInside ? viewH - size.height : viewH)
        case .right:
            origin = CGPoint(x: isInside ? viewW - size.width : viewW, y: (viewH - size.height) * 0.5)
        case .center:
            origin = CGPoint(x: (viewW - size.width) * 0.5, y: (viewH - size.height) * 0.5)
        }
        return CGRect(origin: origin, size: size)
    }
    
    func mapInteractionDirection() -> WQDrivenTransition.Direction {
        var direction: WQDrivenTransition.Direction
        switch self {
        case .center, .top:
            direction = .upwards
        case .left:
            direction = .left
        case .right:
            direction = .right
        case .bottom:
            direction = .down
        case .none:
            direction = .down
        }
        return direction
    }
    /// 内部
    func positionPoint(_ size: CGSize, anchorPoint: CGPoint, viewFrame: CGRect) -> CGPoint {
        var position: CGPoint
        let viewW = viewFrame.width
        let viewH = viewFrame.height
        switch self {
        case .none:
            position = .zero
        case .top:
            position = CGPoint(x: viewW * 0.5, y: size.height * anchorPoint.y)
        case .left:
            position = CGPoint(x: size.width * anchorPoint.x, y: viewH * 0.5)
        case .bottom:
            position = CGPoint(x: viewW * 0.5, y: viewH - size.height * (1.0 - anchorPoint.y))
        case .right:
            position = CGPoint(x: viewW - size.width * (1.0 - anchorPoint.x), y: viewH * 0.5)
        case .center:
            position = CGPoint(x: viewW * 0.5, y: viewH * 0.5)
        }
        return position
    }
}
public extension WQPresentionStyle.Bounce {
    func estimateInitialFrame(_ position: CGPoint,
                              anchorPoint: CGPoint,
                              size: CGSize,
                              presentedFrame: CGRect) -> CGRect {
        let point = position
        let positionPt = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height)
        var origin: CGPoint
        var estSize: CGSize
        switch self {
        case .verticalAuto:
            estSize = CGSize(width: 0, height: size.height)
            if size.width + positionPt.x > presentedFrame.width { //向左
                origin = CGPoint(x: point.x + anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height)
            } else {
                origin = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height)
            }
        case .horizontalAuto:
            estSize = CGSize(width: size.width, height: 0)
            if size.height + positionPt.y > presentedFrame.height {
                origin = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y + anchorPoint.y * size.height)
            } else {
                origin = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height)
            }
        case .bounceCenter:
            origin = positionPt
            estSize = .zero
        case .horizontalMiddle:
            origin = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y)
            estSize = CGSize(width: size.width, height: 0)
        case .verticalMiddle:
            origin = CGPoint(x: point.x, y: point.y - anchorPoint.y * size.height)
            estSize = CGSize(width: 0, height: size.height)
        case .bounceUp:
            origin = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y + anchorPoint.y * size.height)
            estSize = CGSize(width: size.width, height: 0)
        case .bounceDown:
            origin = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height)
            estSize = CGSize(width: size.width, height: 0)
        case .bounceLeft:
            origin = CGPoint(x: point.x + anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height)
            estSize = CGSize(width: 0, height: size.height)
        case .bounceRight:
            origin = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height)
            estSize = CGSize(width: 0, height: size.height)
        }
        return CGRect(origin: origin, size: estSize)
    }
    func postion(_ anchorRect: CGRect, size: CGSize, presentedFrame: CGRect) -> CGPoint {
        let presentionFrame = presentedFrame
        let rect = anchorRect
        var postion: CGPoint
        switch self {
        case .horizontalMiddle, .verticalMiddle, .bounceCenter:
            postion = CGPoint(x: rect.midX, y: rect.midY)
        case .verticalAuto:
            if rect.maxX + size.width > presentionFrame.width {
                postion = CGPoint(x: rect.minX, y: rect.midY)
            } else {
                postion = CGPoint(x: rect.maxX, y: rect.midY)
            }
        case .horizontalAuto:
            if rect.maxY + size.height > presentionFrame.height {
                postion = CGPoint(x: rect.midX, y: rect.midY)
            } else {
                postion = CGPoint(x: rect.maxX, y: rect.midY)
            }
        case .bounceUp:
            postion = CGPoint(x: rect.midX, y: rect.minY)
        case .bounceDown:
            postion = CGPoint(x: rect.midX, y: rect.maxY)
        case .bounceLeft:
            postion = CGPoint(x: rect.minX, y: rect.midY)
        case .bounceRight:
            postion = CGPoint(x: rect.maxX, y: rect.midY)
        }
        return postion
    }
}
