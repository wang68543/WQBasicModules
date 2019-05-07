//
//  WQString+Extensions.swift
//  Pods
//
//  Created by WangQiang on 2019/1/8.
//

import Foundation
public extension String {
    
    /// 序列化URL的查询参数 (可处理包含=)
    ///
    /// - Returns: 键值对 (由于URLString 都是字符串所有这里的键值对类型就是[String: String])
    func serializedURLQueryParameters() -> [String: String] {
        var parameters: [String: String] = [:]
        let string = self.components(separatedBy: "?").last
        guard let queryString = string,
            !queryString.isEmpty else {
            return parameters
        }
        let compments = queryString.components(separatedBy: "&")
        compments.forEach { compment in
            if let range = compment.range(of: "=") {
                let keyRange = Range(uncheckedBounds: (lower: compment.startIndex, upper: range.lowerBound))
                let valueRange = Range(uncheckedBounds: (lower: range.upperBound, upper: compment.endIndex))
                if !keyRange.isEmpty && !valueRange.isEmpty {
                    let key = String(compment[keyRange])
                    let value = String(compment[valueRange])
                    parameters[key] = value
                }
            }
        }
        return parameters
    }
    
    /// 创建二维码
    ///
    /// - Parameter size: 二维码图片尺寸
    /// - Returns: UIImage
    
    @available(*, deprecated, message: "use UIImage.create")
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
            let bitmapRef = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.none.rawValue)
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
