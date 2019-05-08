//
//  UIImage+Extension.swift
//  Pods-WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2019/5/7.
//

import Foundation

// MARK: - -- convenience init
public extension UIImage {
    
    /// 创建二维码图片
    static func create(QRCode content: String, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setDefaults()
        let data = content.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        guard let ciImage = filter.outputImage else { return nil }
        let extent = ciImage.extent.integral
        let scale = min(size.width / extent.width, size.height / extent.height)
        // 创建 bitmap
        guard let bitmapRef = CGContext(data: nil,
                                        width: Int(extent.width * scale),
                                        height: Int(extent.height * scale),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 0,
                                        space: CGColorSpaceCreateDeviceGray(),
                                        bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
                                    return nil
        }
        let context = CIContext(options: nil)
        guard let bitmapImg = context.createCGImage(ciImage, from: extent) else {
            return nil
        }
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImg, in: extent)
        if let scaleImage = bitmapRef.makeImage() {
            return UIImage(cgImage: scaleImage)
        } else {
            return nil
        }
    }
    /// 根据颜色创建图片
    static func create(from color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext()  else {
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
