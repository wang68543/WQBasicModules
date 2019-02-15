//
//  WQStarControl.swift
//  Pods
//
//  Created by HuaShengiOS on 2018/8/15.
//

import UIKit
public enum WQStarValueType {
    case valueHalf, valueWhole, valueRandom // Random is not support custom image
}
open class WQStarControl: UIControl {
    
    public var minimumValue: Int = 0
    public var maximumValue: Int = 1
    /// minimumValue ~ maximumValue
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
    
    public var valueType: WQStarValueType = .valueHalf
    
    ///绘制的图形的角的个数
    public var shapeCoreners: Int = 10 {
        didSet {
            assert(shapeCoreners >= 3, "不支持小于三个角的图形绘制")
        }
    }
    public var normalColor: UIColor = .clear
    public var highlightedColor: UIColor = .red
    public var borderWidth: CGFloat = 1.0
    public var borderColor: UIColor = .red
    
    public var normalImage: UIImage?
    public var halfHighlightedImage: UIImage?
    public var highlightedImage: UIImage?
   
    /// 每个星星之间的最小间距
    public var minInterSpacing: CGFloat = 5
    public var contentEdgeInsets: UIEdgeInsets = .zero
    /// 旋转角度
    public var drawStarRotate: CGFloat = 0.0
    /// 不亮的星星是否不显示
    public var hideUnHighlited = false
    ///是否连续产生事件 为false的时候 只有当结束了才会产生事件
    public var isSendActionContinuous: Bool = true
    
    private var rects: [CGRect] = []
    /// 是否是使用图片绘制
    private var isUsingImage: Bool = false
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let contentRect = self.frame.inset(by: self.contentEdgeInsets)
        let count = CGFloat(counts)
        if self.starSize == .zero {
            if let normalImage = normalImage,
                highlightedImage != nil {
                self.starSize = normalImage.size
            } else {
                let itemW = min((contentRect.width - minInterSpacing * (count - 1)) / count, contentRect.height)
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
                edge.left = (self.frame.width - starSize.width * count - self.minInterSpacing * (count - 1)) * 0.5
                edge.right = edge.left
            case .right:
                edge.left = (self.frame.width - starSize.width * count - self.minInterSpacing * (count - 1))
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
        //更新绘制方式
        shouldUpdateDrawMethod()
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
            let starPoint = CGPoint(x: self.contentEdgeInsets.left + (minInterSpacing + starSize.width) * CGFloat(idx), y: top)
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
        return CGFloat(self.maximumValue - self.minimumValue) / CGFloat(counts)
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
        var progress = min(1.0, max(delt, 0))
        switch self.valueType {
        case .valueWhole:
            progress = ceil(progress) // 向上取整
        case .valueHalf:
            if progress != 0 {
                progress = progress <= 0.5 ? 0.5 : 1
            }
        default: break
        }
        return progress
    }
    //根据外界设置的图片来判定是否使用图片绘制
    func shouldUpdateDrawMethod() {
        guard normalImage != nil else {
            self.isUsingImage = false
            return
        }
        guard highlightedImage != nil else {
            self.isUsingImage = false
            return
        }
        self.isUsingImage = true
        guard halfHighlightedImage != nil else {
            valueType = .valueWhole
            return
        }
        if valueType == .valueRandom { // 不支持random
            valueType = .valueHalf
        }
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
    // 算法参照: https://blog.csdn.net/djh123456021/article/details/78306250
    //swiftlint:disable function_body_length
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
        for index in 0 ..< shapeCoreners { //计算 内外点
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
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
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
        context.setFillColor(highlightedColor.cgColor)
        context.beginPath()
        context.addPath(fillPath.cgPath)
        context.closePath()
        context.drawPath(using: .fill)
        context.restoreGState()
    }
    func drawImage(_ rect: CGRect, progress: CGFloat, context: CGContext) {
        var drawImage: UIImage?
        if progress == 0.0 {
            drawImage = normalImage
        } else if progress == 1.0 {
            drawImage = highlightedImage
        } else if progress == 0.5 {
            if let halfImage = halfHighlightedImage {
                drawImage = halfImage
            } else {
                drawImage = highlightedImage
            }
        } else {
            drawImage = highlightedImage
        }
        UIGraphicsPushContext(context)
        drawImage?.draw(in: rect)
        UIGraphicsPopContext()
    }
    
}
