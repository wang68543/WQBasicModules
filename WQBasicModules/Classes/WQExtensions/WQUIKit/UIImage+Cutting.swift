//
//  UIImage+Cutting.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/9/19.
//

import UIKit
public extension UIImage {
    
    /// 指定区域重绘图片
    func reDraw(_ rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 根据路径裁剪图片
    ///
    /// - Parameters:
    ///   - rect: 区域
    ///   - path: 裁剪路径
    ///   - mode: 裁切模式
    /// - Returns: 裁剪后的图片
    func clip(_ rect: CGRect, path: CGPath, mode: CGPathFillRule = .winding) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let ref = UIGraphicsGetCurrentContext() else {
            return nil
        }
        ref.beginPath()
        ref.addPath(path)
        ref.closePath()
        ref.clip(using: mode)
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 绘制圆或椭圆图片
    func drawInCircle(_ size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        let path = UIBezierPath(ovalIn: rect)
       return clip(rect, path: path.cgPath, mode: .winding)
    }
    
    /// 指定宽或高缩放到适当的大小
    ///
    /// - Parameters:
    ///   - value: 指定值
    ///   - isWidth: 是否是缩放宽度
    ///   - mode: 缩放模式
    func scaleDraw(to value: CGFloat, isWidth: Bool = true, mode: UIView.ContentMode = .scaleToFill) -> UIImage? {
        var drawW: CGFloat = 0.0
        var drawH: CGFloat = 0.0
        if isWidth {
            drawW = value
            drawH = value * (size.height / size.width)
        } else {
            drawH = value
            drawW = value * (size.width / size.height)
        }
       return reDraw(CGRect(origin: .zero, size: CGSize(width: drawW, height: drawH)))
    }
}
public extension Array where Element: UIImage {
    
    /// 图片拼接
    ///
    /// - Parameters:
    ///   - drawSize: 拼接之后图片的尺寸
    ///   - defaultColor: 剩余尺寸的背景颜色
    /// - Returns: image
    /// 图片拼接
    func splice(rounded drawSize: CGSize, cornerRadius: CGFloat = 0, defaultColor: CGColor? = nil) -> UIImage? {
        if cornerRadius > 0 {
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: drawSize), cornerRadius: cornerRadius)
            return self.splice(drawSize, defaultColor: defaultColor, clipPath: path.cgPath)
        } else {
          return self.splice(drawSize, defaultColor: defaultColor)
        }
    }
    ///
    /// - Parameters:
    ///   - drawSize: 绘制尺寸
    ///   - defaultColor: 空白部分的颜色
    ///   - clipPath: 绘制之后的裁剪尺寸
    /// - Returns: image
    func splice(_ drawSize: CGSize, defaultColor: CGColor? = nil, clipPath: CGPath? = nil) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(drawSize, true, scale)
        var offsetH: CGFloat = 0
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
            self.forEach { img  in
                img.draw(in: CGRect(origin: CGPoint(x: 0, y: offsetH), size: img.size))
                offsetH += img.size.height
            }
            context.drawPath(using: .stroke)
        } else {// 无圆角拼接
            self.forEach { img  in
                img.draw(in: CGRect(origin: CGPoint(x: 0, y: offsetH), size: img.size))
                offsetH += img.size.height
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
