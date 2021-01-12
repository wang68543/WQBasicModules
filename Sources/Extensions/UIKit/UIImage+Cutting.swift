//
//  UIImage+Cutting.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/9/19.
//

import UIKit
public extension UIImage {
    
//    /// 指定区域重绘图片
//    func reDraw(_ rect: CGRect, opaque: Bool = false, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, scale)
//        self.draw(in: rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
    
    /// 根据路径裁剪图片
    ///
    /// - Parameters:
    ///   - rect: 区域
    ///   - path: 裁剪路径
    ///   - mode: 裁切模式
    /// - Returns: 裁剪后的图片
//    @available(*, deprecated, message: "use UIImage.render")
//    func clip(_ rect: CGRect, path: CGPath, mode: CGPathFillRule = .winding) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
//        guard let ref = UIGraphicsGetCurrentContext() else {
//            return nil
//        }
//        ref.beginPath()
//        ref.addPath(path)
//        ref.closePath()
//        ref.clip(using: mode)
//        self.draw(in: rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
    
    /// 裁剪图片(解决textView里面的文字用cgimage 无法截取)
//    @available(*, deprecated, message: "use UIImage.render")
//    func clip(toRect cropRect: CGRect, viewSize: CGSize? = nil) -> UIImage? {
//        var imgViewScale: CGFloat = 1.0
//        if let vSize = viewSize {
//            imgViewScale = max(self.size.width / vSize.width,
//                               self.size.height / vSize.height)
//        }
//        /**
//         * // Perform cropping in Core Graphics
//         guard let cutImageRef = self.cgImage?.cropping(to:cropZone) else {
//             return nil
//         }
//         */
//        // Scale cropRect to handle images larger than shown-on-screen size
//        let cropZone = CGRect(x:cropRect.origin.x * imgViewScale,
//                              y:cropRect.origin.y * imgViewScale,
//                              width:cropRect.size.width * imgViewScale,
//                              height:cropRect.size.height * imgViewScale)
//       UIGraphicsBeginImageContextWithOptions(cropZone.size, false, UIScreen.main.scale)
//       self.draw(in: CGRect(x: -cropRect.minX, y: -cropRect.minY, width: self.size.width, height: self.size.height))
//       let image = UIGraphicsGetImageFromCurrentImageContext()
//       UIGraphicsEndImageContext()
//       return image
//
//    }
    /// 绘制圆或椭圆图片
//    func drawInCircle(_ size: CGSize) -> UIImage? {
//        let rect = CGRect(origin: .zero, size: size)
//        let path = UIBezierPath(ovalIn: rect)
//       return clip(rect, path: path.cgPath, mode: .winding)
//    }
    
//    /// 指定宽或高缩放到适当的大小
//    ///
//    /// - Parameters:
//    ///   - value: 指定值
//    ///   - isWidth: 是否是缩放宽度
//    ///   - mode: 缩放模式
//    func scaleDraw(to value: CGFloat, isWidth: Bool = true, mode: UIView.ContentMode = .scaleToFill) -> UIImage? {
//        var drawW: CGFloat = 0.0
//        var drawH: CGFloat = 0.0
//        if isWidth {
//            drawW = value
//            drawH = value * (size.height / size.width)
//        } else {
//            drawH = value
//            drawW = value * (size.width / size.height)
//        }
//       return reDraw(CGRect(origin: .zero, size: CGSize(width: drawW, height: drawH)))
//    }
    /// 裁剪
    func crop(in rect: CGRect) -> UIImage? {
        let path = UIBezierPath(rect: rect)
       return self.render(to: self.size, opaque: false, contentMode: .center, clipPath: path, clipRule: .evenOdd)
    }
    /// 裁剪
    func crop(with path: UIBezierPath) -> UIImage? {
        return self.render(to: self.size, opaque: false, contentMode: .center, clipPath: path, clipRule: .evenOdd)
    }
    
}
public extension Array where Element: UIImage {
    ///
    /// - Parameters:
    ///   - drawSize: 绘制尺寸
    ///   - defaultColor: 空白部分的颜色
    ///   - clipPath: 绘制之后的裁剪尺寸
    ///   - direction: 图片排列方向 0先从上到下 从左到右  1先从左到右 从上到下 (默认0)
    /// - Returns: image
    func splice(_ drawSize: CGSize, defaultColor: CGColor? = nil, clipPath: CGPath? = nil, direction: Int = 0) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(drawSize, true, scale)
        if let color = defaultColor,
            let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color)
            context.addRect(CGRect(origin: .zero, size: drawSize))
            context.drawPath(using: .fill)
        }
        if let path = clipPath,
            let context = UIGraphicsGetCurrentContext() { //裁剪
            context.addPath(path)
            context.clip()
            self.drawImages(drawSize, direction: direction)
            context.drawPath(using: .stroke)
        } else {// 无圆角拼接
            self.drawImages(drawSize, direction: direction)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /// 按照方向拼接图片
    private func drawImages(_ contentSize: CGSize, direction: Int) {
        var offsetY: CGFloat = 0
        var offsetX: CGFloat = 0
        if direction == 0 { //0先从上到下 从左到右
            self.forEach { img  in
                let frame = CGRect(origin: CGPoint(x: offsetX, y: offsetY), size: img.size)
                img.draw(in: frame)
                offsetY += img.size.height
                if offsetY >= contentSize.height {
                    offsetY = 0
                    offsetX += img.size.width
                }
            }
        } else { // 1先从左到右 从上到下
            self.forEach { img  in
                let frame = CGRect(origin: CGPoint(x: offsetX, y: offsetY), size: img.size)
                img.draw(in: frame)
                offsetX += img.size.width
                if offsetX >= contentSize.width {
                    offsetX = 0
                    offsetY += img.size.height
                }
            }
        }
       
    }
}
