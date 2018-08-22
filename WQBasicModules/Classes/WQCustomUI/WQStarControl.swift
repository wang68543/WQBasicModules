//
//  WQStarControl.swift
//  Pods
//
//  Created by HuaShengiOS on 2018/8/15.
//

import UIKit
public enum WQStarValueType {
    case valueHalf, valueWhole, valueRandom
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
    public var minInterSpacing: CGFloat = 5
    /// 0 ~ 100
    public var value: Int {
            set {
                let starProgress = CGFloat(min(max(0, newValue), 100)) / 100.0
                self.progressValue = starProgress
            }
            get {
                let contentRect = UIEdgeInsetsInsetRect(self.frame, self.contentEdgeInsets)
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
                return Int(100 / CGFloat(starCount) * (progress + includeStar))
            }
    }
    
    public var valueType: WQStarValueType = .valueHalf
    public var contentEdgeInsets: UIEdgeInsets = .zero
    public var drawStarRotate: CGFloat = 0.0
    public var starSize: CGSize  = .zero
 
    public var hideUnHighlited = false
    ///默认形状(五角形)
    public var shapeCoreners: Int = 5
    public var starCount: Int = 5
    
    public var normalImage: UIImage?
    public var halfHighlightedImage: UIImage?
    public var highlightedImage: UIImage?
 
    public var normalColor: UIColor = .clear
    public var highlightedColor: UIColor = .red
    public var borderWidth: CGFloat = 1.0
    public var borderColor: UIColor = .red
    
    private var starRects: [CGRect] = []
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let contentRect = UIEdgeInsetsInsetRect(self.frame, self.contentEdgeInsets)
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
                debugPrint("星星的尺寸必须小于控件的尺寸")
                return
        }
        if normalImage != nil && highlightedImage != nil {
            if halfHighlightedImage != nil && valueType == .valueRandom {
                 valueType = .valueHalf
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
        var rects: [CGRect] = []
        for idx in 0 ..< starCount {
            let starPoint = CGPoint(x: self.contentEdgeInsets.left + (minInterSpacing + starSize.width) * CGFloat(idx), y: top)
            let starRect = CGRect(origin: starPoint, size: starSize)
            rects.append(starRect)
            drawItem(starRect, context: context)
        }
        self.starRects = rects
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
            handleTouch(touch)
        }
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
}
/// 画单个
private extension WQStarControl {
    func handleTouch(_ touch: UITouch) {
        let point = touch.location(in: self)
        var progress: CGFloat
        if point.x <= self.contentEdgeInsets.left {
            progress = 0.0
        } else if point.x >= self.frame.width - self.contentEdgeInsets.right {
            progress = 1.0
        } else {
            let contentRect = UIEdgeInsetsInsetRect(self.frame, self.contentEdgeInsets)
            progress = (point.x - self.contentEdgeInsets.left) / contentRect.width
        }
        let oldValue = self.value
        self.progressValue = progress
        if self.value != oldValue {
            self.sendActions(for: .valueChanged)
        }
    }
    func drawItem(_ rect: CGRect, context: CGContext) {
        let contentRect = UIEdgeInsetsInsetRect(self.frame, self.contentEdgeInsets)
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
    //  swiftlint:disable function_body_length
    func drawStar(_ rect: CGRect, progress: CGFloat, context: CGContext) {
        let angle = 360.0 / CGFloat(shapeCoreners)
        let innerAngle = angle * 0.5
        let radius = min(rect.width, rect.height) * 0.5
        let innerR = radius * 0.3
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let offsetAngle: CGFloat = -90
        let radian = CGFloat.pi / 180.0
        let progressX = progress * rect.width + rect.minX
        let path = UIBezierPath()
        let progressPath = UIBezierPath()
        for idx in 0 ..< shapeCoreners {
            let topCornerAngle = offsetAngle + angle * CGFloat(idx)
            let pt1Radian = (topCornerAngle - innerAngle) * radian
            let pt1 = CGPoint(x: cos(pt1Radian) * innerR + center.x, y: sin(pt1Radian) * innerR + center.y)
            let pt2Radian = topCornerAngle * radian
            let pt2 = CGPoint(x: cos(pt2Radian) * radius + center.x, y: sin(pt2Radian) * radius + center.y)
            let pt3Radian = (topCornerAngle + innerAngle) * radian
            let pt3 = CGPoint(x: cos(pt3Radian) * innerR + center.x, y: sin(pt3Radian) * innerR + center.y)
            if idx == 0 { path.move(to: pt1 ) }
            path.addLine(to: pt2)
            path.addLine(to: pt3)
            if progress > 0.0 && progress < 1.0 {
                if pt1.x <= progressX || pt2.x <= progressX {
                    let line1Pt = twoLineIntersection(pt1, point2: pt2, intersectionX: progressX)
                    let start: CGPoint = pt1.x <= progressX ? pt1 : line1Pt
                    let end: CGPoint = pt2.x <= progressX ? pt2 : line1Pt
                    if progressPath.isEmpty {
                        progressPath.move(to: start)
                    } else if progressPath.currentPoint != start {
                        progressPath.addLine(to: start)
                    }
                    progressPath.addLine(to: end)
                }
                if pt2.x <= progressX || pt3.x <= progressX {
                    let line2Pt = twoLineIntersection(pt2, point2: pt3, intersectionX: progressX)
                    let start: CGPoint = pt2.x <= progressX ? pt2 : line2Pt
                    let end: CGPoint = pt3.x <= progressX ? pt3 : line2Pt
                    if progressPath.isEmpty {
                        progressPath.move(to: start)
                    } else if progressPath.currentPoint != start {
                        progressPath.addLine(to: start)
                    }
                    progressPath.addLine(to: end)
                }
            }
        }
        path.close()
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
        context.setLineJoin(.round)
        context.beginPath()
        context.addPath(path.cgPath)
        context.closePath()
        if progress == 1.0 {
            context.setFillColor(highlightedColor.cgColor)
            context.drawPath(using: .fillStroke)
        } else {
            context.setFillColor(normalColor.cgColor)
            context.drawPath(using: .stroke)
            if !progressPath.isEmpty {
                progressPath.close()
                context.setFillColor(highlightedColor.cgColor)
                context.beginPath()
                context.addPath(progressPath.cgPath)
                context.closePath()
                context.drawPath(using: .fill)
            }
        }
    }
    func twoLineIntersection(_ point1: CGPoint, point2: CGPoint, intersectionX: CGFloat) -> CGPoint {
        let lineK = (point1.y - point2.y) / (point1.x - point2.x)
        let lineb = point1.y - lineK * point1.x
        let linePt = CGPoint(x: intersectionX, y: lineK * intersectionX + lineb)
        return linePt
    }
    func drawImage(_ rect: CGRect, progress: CGFloat, context: CGContext) {
        var drawImage: UIImage?
        if progress == 0.0 {
            drawImage = normalImage
        } else if progress == 1.0 {
            drawImage = highlightedImage
        } else {
            if let halfImage = halfHighlightedImage {
                drawImage = halfImage
            } else {
                drawImage = highlightedImage
            }
        }
        UIGraphicsPushContext(context)
        drawImage?.draw(in: rect)
        UIGraphicsPopContext()
    }
    
}
