//
//  WQString+ExtraCode.swift
//  FBSnapshotTestCase
//
//  Created by hejinyin on 2018/1/31.
//

import Foundation
public extension String {
    /// md5加密 默认小写
    func md5(lower: Bool = true) -> String {
        let str = self as NSString
        var md5Str: String
        if lower {
            md5Str = str.md5Lowercase()
        } else {
            md5Str = str.md5()
        }
        return md5Str
    }
    
   func oc_sha1() -> String {
        let str = self as NSString 
        return str.sha1()
    }
    
    func QRCode(_ size: CGSize) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = self.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        if let ciImage = filter?.outputImage {
            let extent = ciImage.extent.integral
            let scale = min(size.width / extent.width, size.height / extent.height)
            // 创建 bitmap
            let width = Int(extent.width * scale)
            let height = Int(extent.height * scale)
            let colorSpace = CGColorSpaceCreateDeviceGray()
            let bitmapRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
            let context = CIContext(options: nil)
            let bitmapImage = context.createCGImage(ciImage, from: extent)
            bitmapRef?.interpolationQuality = .none
            bitmapRef?.scaleBy(x: scale, y: scale)
            if let bitmapImg = bitmapImage {
                bitmapRef?.draw(bitmapImg, in: extent)
            }
            if let scaleImage = bitmapRef?.makeImage() {
                return UIImage(cgImage: scaleImage)
            } 
            return nil
        } else {
            return nil
        }
        
    }
}
