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
