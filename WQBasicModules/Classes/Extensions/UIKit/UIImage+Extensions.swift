//
//  UIImage+Extension.swift
//  Pods-WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2019/5/7.
//

import Foundation

// MARK: - -- convenience init
public extension UIImage {
    
    /// 根据颜色创建图片
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size)) 
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        
        self.init(cgImage: aCgImage)
    }
    
    /// 创建线性渐变的图片
    ///
    /// - Parameters:
    ///   - colors: 颜色
    ///   - size: 尺寸
    ///   - start: 线性起点
    ///   - end: 线性终点
    ///   - locations: 分割点
    ///   - options: 绘制方式,DrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制， DrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
    convenience init(linearGradient colors: [CGColor],
                     size: CGSize,
                     startPoint start: CGPoint = CGPoint(x: 0.5, y: 1),
                     endPoint end: CGPoint = CGPoint(x: 0.5, y: 1),
                     locations: [CGFloat]? = nil,
                     options: CGGradientDrawingOptions = .drawsBeforeStartLocation) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            self.init()
            return
        }
        let rgb = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = colors.flatMap { color -> [CGFloat] in
            return color.components ?? []
        }
        guard let gradient = CGGradient(colorSpace: rgb, colorComponents: components, locations: locations, count: colors.count) else {
            self.init()
            return
        }
        // 第四个参数是定义渐变是否超越起始点和终止点
        let startPoint = CGPoint(x: start.x * size.width, y: start.y * size.height)
        let endPoint = CGPoint(x: end.x * size.width, y: end.y * size.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        } 
        self.init(cgImage: aCgImage)
    }
    
    /// 绘制线性渐变  https://www.jianshu.com/p/cd2d1f374a39
    ///
    /// - Parameters:
    ///   - colors: 颜色
    ///   - size: 尺寸
    ///   - start: 起始位置
    ///   - sRadius: 起始半径（通常为0，否则在此半径范围内容无任何填充）
    ///   - end: 终点位置（通常和起始点相同，否则会有偏移）
    ///   - eRadius: 终点半径（也就是渐变的扩散长度）
    ///   - options: 绘制方式,DrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制， DrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
    convenience init(radialGradient colors: [CGColor],
                     size: CGSize,
                     startCenter start: CGPoint = CGPoint(x: 0.5, y: 0.5),
                     startRaidus sRadius: CGFloat = 0,
                     endCenter end: CGPoint = CGPoint(x: 0.5, y: 0.5),
                     endRaidus eRadius: CGFloat,
                     options: CGGradientDrawingOptions) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            self.init()
            return
        }
        let rgb = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = colors.flatMap { color -> [CGFloat] in
            return color.components ?? []
        }
        guard let gradient = CGGradient(colorSpace: rgb, colorComponents: components, locations: nil, count: colors.count) else {
            self.init()
            return
        }
        // 第四个参数是定义渐变是否超越起始点和终止点
        let startPoint = CGPoint(x: start.x * size.width, y: start.y * size.height)
        let endPoint = CGPoint(x: end.x * size.width, y: end.y * size.height)
        context.drawRadialGradient(gradient,
                                   startCenter: startPoint,
                                   startRadius: sRadius,
                                   endCenter: endPoint,
                                   endRadius: eRadius,
                                   options: options)
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    /// 根据文字创建二维码
    ///
    /// - Parameters:
    ///   - text: 文字内容
    ///   - size: 图片尺寸
    convenience init(text: String, size: CGSize = CGSize(width: 100, height: 100)) {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            self.init()
            return
        }
        filter.setDefaults()
        let data = text.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        guard let ciImage = filter.outputImage else {
            self.init()
            return
        }
        let extent = ciImage.extent.integral
        let scale = min(size.width / extent.width, size.height / extent.height)
        let width = Int(extent.width * scale)
        let height = Int(extent.height * scale)
        let spaceGray = CGColorSpaceCreateDeviceGray()
        let alpha = CGImageAlphaInfo.none.rawValue
        let bitmap = CGContext(data: nil,
                               width: width,
                               height: height,
                               bitsPerComponent: 8,
                               bytesPerRow: 0,
                               space: spaceGray,
                               bitmapInfo: alpha)
        // 创建 bitmap
        guard let bitmapRef = bitmap else {
               self.init()
               return
        }
        let context = CIContext(options: nil)
        guard let bitmapImg = context.createCGImage(ciImage, from: extent) else {
            self.init()
            return
        }
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImg, in: extent)
        guard let scaleImage = bitmapRef.makeImage() else {
            self.init()
            return
        }
         self.init(cgImage: scaleImage)
    }
}
public extension UIImage {
    /// SwifterSwift: UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     拉伸两端，保留中间
     
     @param image 需要拉伸的图片
     @param desSize 目标大小
     @param stretchLeftBorder 拉伸图片距离左边的距离
     @param top inset.top
     @param bottom inset.bottom
     @return 拉伸收缩后的图片
     */
    func stretchBothSides(_ destSize: CGSize, padding leading: CGFloat, top: CGFloat, bottom: CGFloat) -> UIImage? {
        guard destSize.width != 0 else { return nil }
        var imageSize = self.size
        var desSize = destSize
        guard abs(desSize.width - imageSize.width) > 4 else { return self }
        
        imageSize.width = floor(imageSize.width)
        
        desSize.width   = floor(desSize.width)
        let desSizeThan = desSize.width > imageSize.width
        
        //各需要拉伸的宽度
        let needWidth = (desSize.width - imageSize.width) / 2.0
        
        //先拉取左边
        var left = leading
        var right = desSizeThan ? (imageSize.width - left - 1) : (imageSize.width - abs(needWidth) - left)
        
        //画图， 生成拉伸的左边后的图片
        var tempStrecthWith = imageSize.width + needWidth
        
        //生成拉伸后的图片-》左
        let height = imageSize.height
        var strectedImage = self.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: tempStrecthWith, height: height), false, self.scale)
        strectedImage.draw(in: CGRect(x: 0, y: 0, width: tempStrecthWith, height: height))
        
        defer {
            UIGraphicsEndImageContext()
        }
        guard let getImg = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        strectedImage = getImg
        //拉伸右边
        right = leading
        left  = desSizeThan ? (strectedImage.size.width - right - 1) : (strectedImage.size.width - right - abs(needWidth))
        //生成拉伸后的图片-》右
        tempStrecthWith = desSize.width
        strectedImage = strectedImage.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
         UIGraphicsBeginImageContextWithOptions(CGSize(width: tempStrecthWith, height: height), false, self.scale)
        strectedImage.draw(in: CGRect(x: 0, y: 0, width: tempStrecthWith, height: height))
        guard let getRightImg = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        strectedImage = getRightImg
        return strectedImage.resizableImage(withCapInsets: UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0))
    }
    
     /**
      根据坐标获取图片中的像素颜色值
      */
     subscript (x: Int, y: Int) -> UIColor? {
        guard x >= 0 && x <= Int(size.width) && y >= 0 && y <= Int(size.height) else { return nil }
        guard let provider = self.cgImage?.dataProvider,
        let data = CFDataGetBytePtr(provider.data) else {
            return nil
        }
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * y) + x) * numberOfComponents
        let r = CGFloat(data[pixelData]) / 255.0
        let g = CGFloat(data[pixelData + 1]) / 255.0
        let b = CGFloat(data[pixelData + 2]) / 255.0
        let a = CGFloat(data[pixelData + 3]) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
     }
}
