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
    /// 0.0 ~ 1.0
    private var progressValue: CGFloat = 0.0 {
        didSet {
            if progressValue != oldValue {
              self.setNeedsDisplay()
            }
        }
    }
    //是否连续产生事件
    public var isContinuous: Bool = true
    public var minimumValue: Int = 0
    public var maximumValue: Int = 100
    /// 0 ~ 100
    public var value: Int {
            set {
                let starProgress = CGFloat(min(max(minimumValue, newValue), maximumValue)) / CGFloat(maximumValue - minimumValue)
                self.progressValue = starProgress
            }
            get {
                let contentRect = self.frame.inset(by: self.contentEdgeInsets)
                let progressX = contentRect.width * self.progressValue
                let includeStar = floor(progressX / (starSize.width + minInterSpacing))
                var progress = (progressX - (starSize.width + minInterSpacing) * includeStar) / starSize.width
                progress = min(progress, 1.0)
                if progress > 0.0 {
                    switch valueType {
                    case .valueHalf:
                        progress = progress > 0.5 ? 1.0 : 0.5
                    case .valueWhole:
                        progress = 1.0
                    default:
                        break
                    }
                }
                return Int(CGFloat(maximumValue - minimumValue) / CGFloat(starCount) * (progress + includeStar)) + minimumValue
            }
    }
    
    public var minInterSpacing: CGFloat = 5
    
    public var valueType: WQStarValueType = .valueHalf
    public var contentEdgeInsets: UIEdgeInsets = .zero
    /// 旋转角度
    public var drawStarRotate: CGFloat = 0.0
    public var starSize: CGSize  = .zero
 
    public var hideUnHighlited = false
    ///默认形状(五角形)
    public var shapeCoreners: Int = 4
    public var starCount: Int = 5
    
    public var normalImage: UIImage?
    public var halfHighlightedImage: UIImage?
    public var highlightedImage: UIImage?
 
    public var normalColor: UIColor = .clear
    public var highlightedColor: UIColor = .red
    public var borderWidth: CGFloat = 1.0
    public var borderColor: UIColor = .red
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let contentRect = self.frame.inset(by: self.contentEdgeInsets)
        if self.starSize == .zero {
            if let normalImage = normalImage,
                highlightedImage != nil {
                self.starSize = normalImage.size
            } else {
                let itemW = min((contentRect.width - minInterSpacing * CGFloat(starCount - 1)) / CGFloat(starCount), contentRect.height)
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
                edge.left = (self.frame.width - starSize.width * CGFloat(starCount) - self.minInterSpacing * CGFloat(starCount - 1)) * 0.5
                edge.right = edge.left
            case .right:
                edge.left = (self.frame.width - starSize.width * CGFloat(starCount) - self.minInterSpacing * CGFloat(starCount - 1))
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
        if normalImage != nil && highlightedImage != nil {
            if halfHighlightedImage != nil {
                if valueType == .valueRandom {
                    valueType = .valueHalf
                }
            } else {
                if valueType != .valueWhole {
                    valueType = .valueWhole
                }
            }
        }
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.clear(rect)
        context.setFillColor(self.backgroundColor?.cgColor ?? UIColor.clear.cgColor)
        context.fill(rect)
        
        let top = self.contentEdgeInsets.top 
        for idx in 0 ..< starCount {
            let starPoint = CGPoint(x: self.contentEdgeInsets.left + (minInterSpacing + starSize.width) * CGFloat(idx), y: top)
            let starRect = CGRect(origin: starPoint, size: starSize)
            drawItem(starRect, context: context)
        }
    }
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        if !self.isFirstResponder {
            self.becomeFirstResponder()
        }
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
        if self.isFirstResponder {
            self.resignFirstResponder()
        }
        if let touch = touch {
            handleTouch(touch, isEnd: true)
        }
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
}
/// 画单个
private extension WQStarControl {
    func handleTouch(_ touch: UITouch, isEnd: Bool = false) {
        let point = touch.location(in: self)
        var progress: CGFloat
        if point.x <= self.contentEdgeInsets.left {
            progress = 0.0
        } else if point.x >= self.frame.width - self.contentEdgeInsets.right {
            progress = 1.0
        } else {
            let contentRect = self.frame.inset(by: self.contentEdgeInsets)
            progress = (point.x - self.contentEdgeInsets.left) / contentRect.width
        }
        self.progressValue = progress
        if isContinuous {
           self.sendActions(for: .valueChanged)
        } else {
            if isEnd {
                self.sendActions(for: .valueChanged)
            }
        }
    }
    func drawItem(_ rect: CGRect, context: CGContext) {
        let contentRect = self.frame.inset(by: self.contentEdgeInsets)
        var progress: CGFloat
        let progressX = contentRect.width * self.progressValue + self.contentEdgeInsets.left
        
        if progressX >= rect.maxX {
            progress = 1.0
        } else if progressX <= rect.minX {
            progress = 0.0
        } else {
            progress = (progressX - rect.minX) / rect.width
            switch valueType {
            case .valueHalf:
                progress = progress > 0.5 ? 1.0 : 0.5
            case .valueWhole:
                progress = ceil(progress)
            default:
                break
            }
        }
        if  normalImage != nil && highlightedImage != nil {
            drawImage(rect, progress: progress, context: context)
        } else {
            drawStar(rect, progress: progress, context: context)
        }
  }
    // 算法参照: https://blog.csdn.net/djh123456021/article/details/78306250
    func drawStar(_ rect: CGRect, progress: CGFloat, context: CGContext) {
        let count = CGFloat(shapeCoreners)
        let degree = 180 / count
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
        for index in 0 ..< shapeCoreners { // 绘制五角星
            let idx = (index + 1) % pts.count
            let pt2 = pts[idx]
            let midPt = internalPts[index]
            path.addLine(to: midPt)
            path.addLine(to: pt2)
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
