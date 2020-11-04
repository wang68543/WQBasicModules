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
}
