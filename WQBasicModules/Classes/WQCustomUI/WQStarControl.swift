//
//  WQStarControl.swift
//  Pods
//
//  Created by HuaShengiOS on 2018/8/15.
//

import UIKit

public class WQStarControl: UIControl {
    /// 0 ~ 100
    var value:Int = 0
    var contentEdgeInsets: UIEdgeInsets = .zero
    var drawStarRotate:CGFloat = 0.0
    var starSize:CGSize  = .zero
    var isHalfEnable:Bool = true
    
    var hideUnHighlited = false
    
    var starCount: Int = 5
    
    var normalImage: UIImage?
    var halfHighlightedImage: UIImage?
    var highlightedImage: UIImage?
    
    var normalColor: UIColor = .clear
    var highlightedColor: UIColor = .red
    var borderWidth: CGFloat = 1.0
    var borderColor: UIColor = .red
    
    private var starRects:[CGRect] = []
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        let contentRect = UIEdgeInsetsInsetRect(self.frame, self.contentEdgeInsets)
        guard self.starSize.height <= contentRect.height,
            self.starSize.width <= contentRect.width else {
                debugPrint("星星的尺寸必须小于控件的尺寸")
                return
        }
        if self.starSize == .zero {
            if let _ = normalImage, let _ = highlightedImage {
                self.starSize = normalImage!.size
            } else {
                let minimumInteritemSpacing:CGFloat = 5
                let itemW = min((contentRect.width - minimumInteritemSpacing * CGFloat(starCount - 1))/CGFloat(starCount), contentRect.height)
                starSize = CGSize(width: itemW, height: itemW)
            }
        }
        let sectionW = (contentRect.width - starSize.width * CGFloat(starCount)) / CGFloat(starCount - 1)
        let top = self.contentEdgeInsets.top
        var rects:[CGRect] = []
        for idx in 0 ..< starCount {
            let starRect = CGRect(origin: CGPoint(x: self.contentEdgeInsets.left + (sectionW + starSize.width) * CGFloat(idx), y: top), size: starSize)
            rects.append(starRect)
            drawItem(starRect)
        }
        self.starRects = rects
    }
    
}
/// 画单个
private extension WQStarControl {
    func drawItem(_ rect: CGRect) {
       let contentRect = UIEdgeInsetsInsetRect(self.frame, self.contentEdgeInsets)
        var progress: CGFloat
        let progressX = contentRect.width *  CGFloat(value) + self.contentEdgeInsets.left
        if progressX >= rect.maxX {
            progress = 1.0
        } else if progressX <= rect.minX {
            progress = 0.0
        } else {
            progress = (progressX - rect.minX) / rect.width
        }
        
        if let _ = normalImage, let _ = highlightedImage {
            if progress > 0.0 {
                progress = progress > 0.5 ? 1.0 : 0.5
            }
            drawImage(rect, progress: progress)
        } else {
            if isHalfEnable && progress > 0.0 {
                progress = progress > 0.5 ? 1.0 : 0.5
            }
            drawStar(rect, progress: progress)
        }
        
  }
    func drawStar(_ rect:CGRect, progress: CGFloat) {
        let corenersCount = 5
        let angle = 360.0 / CGFloat(corenersCount)
        let innerAngle = 90 - angle * 0.5
        let outAngle = 90 - angle
        let radius = min(rect.width , rect.height) * 0.5
        let innerR = radius * 0.3
        let center = CGPoint(x: rect.midX, y: rect.midY)
//        let offsetAngle: CGFloat = -90
         let offsetAngle: CGFloat = 0.0
        let radian = CGFloat.pi / 180.0
        let path = UIBezierPath()
        for idx in 0 ..< corenersCount {//
            let topCornerAngle = offsetAngle + angle * CGFloat(idx)
            if idx == 0 {
                //
            let start = CGPoint(x: cos(-18 * radian) * innerR + center.x , y: sin(-18                                                                                                                                    * radian) * innerR + center.y)
                debugPrint("==========",topCornerAngle - innerAngle)
                debugPrint(start)
               path.move(to: start )
         
            }
            let outRadian = (topCornerAngle + outAngle) * radian
            path.addLine(to: CGPoint(x: cos(outRadian) * radius + center.x, y: sin(outRadian) * radius + center.y))
            let innerRadian = (topCornerAngle + innerAngle) * radian
            let innerPoint = CGPoint(x: cos(innerRadian) * innerR + center.x , y: sin(innerRadian) * innerR + center.y)
            path.addLine(to: innerPoint)
            debugPrint(innerPoint,"====",topCornerAngle + innerAngle)
        }
        borderColor.setStroke()
        normalColor.setFill()
        path.close()
        path.lineWidth = borderWidth
        path.lineJoinStyle = .round
        path.stroke()
        path.fill()
        
    }
    func drawImage(_ rect: CGRect, progress: CGFloat) {
        if progress == 0.0  {
            self.normalImage!.draw(in: rect)
        } else if progress == 1.0 {
            self.highlightedImage!.draw(in: rect)
        } else {
            if let halfImage = self.halfHighlightedImage {
                halfImage.draw(in: rect)
            } else {
                self.highlightedImage!.draw(in: rect)
            }
        }
    }
    
}
