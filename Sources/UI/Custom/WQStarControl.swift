//
//  WQStarControl.swift
//  Pods
//
//  Created by HuaShengiOS on 2018/8/15.
//

import UIKit
open class WQStarControl: UIControl {
    public var maximumValue: Double = 10
    public var value: CGFloat = 0 {
        didSet {
            guard value != oldValue else {
                return
            }
            self.setNeedsDisplay()
        }
    }
    /// 这里如果是zero的话 会根据当前frame 动态计算出合适的尺寸
    public var starSize: CGSize  = .zero
    /// polygon counts
    public var counts: Int = 5

    /// 绘制的图形的角的个数
    public var shapeCoreners: Int = 5 {
        didSet {
            assert(shapeCoreners >= 3, "不支持小于三个角的图形绘制")
        }
    }

    /// 使用绘制的星星
    public var selectedColor: UIColor = .red
    public var unSelectedColor: UIColor = .clear
    public var starBorderWidth: CGFloat = 1.0
    public var starBorderColor: UIColor = .red

    public var selectedImage: UIImage?
    public var unSelectedImage: UIImage?

    /// 每个星星之间的最小间距
    public var minItemSpacing: CGFloat = 5
    public var contentEdgeInsets: UIEdgeInsets = .zero
    /// 旋转角度
    public var drawStarRotate: CGFloat = 0.0
    /// 不亮的星星是否不显示
    public var hideUnHighlited = false
    /// 是否连续产生事件 为false的时候 只有当结束了才会产生事件
    public var isSendActionContinuous: Bool = true

    private var rects: [CGRect] = []
    /// 是否是使用图片绘制
    private var isUsingImage: Bool {
        return self.unSelectedImage != nil && self.selectedImage != nil
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let contentRect = self.frame.inset(by: self.contentEdgeInsets)
        let count = CGFloat(counts)
        if self.starSize == .zero {
            if self.isUsingImage {
                self.starSize = selectedImage!.size
            } else {
                let itemW = min((contentRect.width - minItemSpacing * (count - 1)) / count, contentRect.height)
                starSize = CGSize(width: itemW, height: itemW)
            }
        }
        if self.contentEdgeInsets == .zero {
            var edge: UIEdgeInsets = .zero
            switch self.contentVerticalAlignment {
            case .center, .fill:
                edge.top = (self.frame.height - starSize.height) * 0.5
                edge.bottom = edge.top
            case .bottom:
                edge.top = self.frame.height - starSize.height
                edge.bottom = 0.0
            default:
                break
            }
            switch self.contentHorizontalAlignment {
            case .center, .fill:
                edge.left = (self.frame.width - starSize.width * count - self.minItemSpacing * (count - 1)) * 0.5
                edge.right = edge.left
            case .right:
                edge.left = (self.frame.width - starSize.width * count - self.minItemSpacing * (count - 1))
                edge.right = 0
            default:
                break
            }
            self.contentEdgeInsets = edge
        }
        guard self.starSize.height <= contentRect.height,
            self.starSize.width <= contentRect.width else {
                debugPrint("星星的尺寸必须小于控件的尺寸");return
        }
        // 更新绘制方式
//        shouldUpdateDrawMethod()
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        context.setFillColor(self.backgroundColor?.cgColor ?? UIColor.clear.cgColor)
        context.fill(rect)

        let top = self.contentEdgeInsets.top
        var items: [CGRect] = []
        for idx in 0 ..< counts {
            let starPoint = CGPoint(x: self.contentEdgeInsets.left + (minItemSpacing + starSize.width) * CGFloat(idx), y: top)
            let starRect = CGRect(origin: starPoint, size: starSize)
            items.append(starRect)
            drawItem(starRect, index: idx, context: context)
        }
        rects = items
    }
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        if !self.isFirstResponder { self.becomeFirstResponder() }
        handleTouch(touch)
        return true
    }
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        handleTouch(touch)
        return true
    }
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if self.isFirstResponder { self.resignFirstResponder() }
        if let touch = touch {
            handleTouch(touch, isEnd: true)
        }
    }

    open override var canBecomeFirstResponder: Bool {
        return true
    }
}
private extension WQStarControl {
    /// 每个星星的分值
    var starValue: CGFloat {
        return CGFloat(self.maximumValue - 0) / CGFloat(counts)
    }
    /// 根据坐标点获取进度
    func value(for point: CGPoint) -> CGFloat {
        guard !rects.isEmpty else { return 0.0 }
        var minX: CGFloat = 0.0
        var maxIndex: CGFloat = -1
        var rectW: CGFloat = 0
        for rect in rects {
            if rect.minX < point.x {
                minX = rect.minX
                rectW = rect.width
                maxIndex += 1
            } else {
                break
            }
        }
        if maxIndex < 0 {
            return 0.0
        } else {
            return (maxIndex + min(1, (point.x - minX) / rectW)) * starValue
        }
    }
    // 计算每个星星的刻画进度
    func progress(for index: Int) -> CGFloat {
        let count = value / starValue
        let idx = CGFloat(index)
        let delt = count - idx
        return min(1.0, max(delt, 0))
    }
}
/// 画单个
private extension WQStarControl {

    func handleTouch(_ touch: UITouch, isEnd: Bool = false) {
        let point = touch.location(in: self)
        self.value = value(for: point)
        guard isEnabled else { return }
        if isSendActionContinuous {
           self.sendActions(for: .valueChanged)
        } else {
            if isEnd {
                self.sendActions(for: .valueChanged)
            }
        }
    }
    func drawItem(_ rect: CGRect, index: Int, context: CGContext) {
        let progress = self.progress(for: index)
        guard !self.hideUnHighlited || progress > 0 else { return } // 隐藏不亮的星星
        if  self.isUsingImage {
            drawImage(rect, progress: progress, context: context)
        } else {
            drawStar(rect, progress: progress, context: context)
        }
  }
    //https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E5%88%A9%E7%94%A8-cgaffinetransform-%E6%8E%A7%E5%88%B6%E5%85%83%E4%BB%B6%E7%B8%AE%E6%94%BE-%E4%BD%8D%E7%A7%BB-%E6%97%8B%E8%BD%89%E7%9A%84%E4%B8%89%E7%A8%AE%E6%96%B9%E6%B3%95-dca1abbf9590 可参照这个 
    // 算法参照: https://blog.csdn.net/djh123456021/article/details/78306250
    // swiftlint:disable function_body_length
    func drawStar(_ rect: CGRect, progress: CGFloat, context: CGContext) {
        let count = CGFloat(shapeCoreners)
        let degree = 180 / count // 内角和
        context.saveGState()
        let splitAngle = 360.0 / count // 圆上点的分割弧度
        let radius = min(rect.width, rect.height) * 0.5 // 外角半斤
        let center = CGPoint(x: rect.midX, y: rect.midY) // 圆心
        let radian = CGFloat.pi / 180.0
        let internalRadius = radius * sin(degree * 0.5 * radian) / cos(splitAngle * 0.5 * radian) // 内角半径
        var pts: [CGPoint] = [] // 外角点集合
        var internalPts: [CGPoint] = []
        for index in 0 ..< shapeCoreners { // 计算 内外点
            let angle1 = (splitAngle * CGFloat(index) + drawStarRotate) * radian
            let pt1 = CGPoint(x: center.x + sin(angle1) * radius, y: center.y - cos(angle1) * radius)
            pts.append(pt1)
            let angle2 = (splitAngle * CGFloat(index) + drawStarRotate + splitAngle * 0.5) * radian
            let pt2 = CGPoint(x: center.x + sin(angle2) * internalRadius, y: center.y - cos(angle2) * internalRadius)
            internalPts.append(pt2)
        }
        let path = UIBezierPath()
        path.move(to: pts.first!)
        if shapeCoreners == 3 {
            for index in 0 ..< shapeCoreners { // special for triangle
                let idx = (index + 1) % pts.count
                let pt2 = pts[idx]
                path.addLine(to: pt2)
            }
        } else {
            for index in 0 ..< shapeCoreners { // draw polygon
                let idx = (index + 1) % pts.count
                let pt2 = pts[idx]
                let midPt = internalPts[index]
                path.addLine(to: midPt)
                path.addLine(to: pt2)
            }
        }
        path.close()
        path.addClip()
        context.setStrokeColor(starBorderColor.cgColor)
        context.setLineWidth(starBorderWidth)
        context.setLineJoin(.round)
        context.setLineCap(.round)
        context.beginPath()
        context.addPath(path.cgPath)
        context.closePath()
        context.drawPath(using: .fillStroke)
        // 填充
        let fillPath = UIBezierPath(rect: CGRect(x: rect.minX, y: rect.minY, width: rect.width * progress, height: rect.height))
        fillPath.close()
        context.setLineWidth(0)
        context.setFillColor(selectedColor.cgColor)
        context.beginPath()
        context.addPath(fillPath.cgPath)
        context.closePath()
        context.drawPath(using: .fill)
        context.restoreGState()
    }

    /// 绘制图片
    func drawImage(_ rect: CGRect, progress: CGFloat, context: CGContext) {
        if !self.hideUnHighlited {
           unSelectedImage?.draw(in: rect)
        }
        if progress > 0.0 {
            if progress < 1.0 {
                context.saveGState()
                context.beginPath()
                let ctRect = CGRect(origin: rect.origin, size: CGSize(width: rect.width * progress, height: rect.height))
                 context.addRect(ctRect)
                 context.closePath()
                 context.clip(using: .winding)
                 selectedImage?.draw(in: rect)
                 context.restoreGState()
            } else {
                selectedImage?.draw(in: rect)
            }
        }
    }

}
