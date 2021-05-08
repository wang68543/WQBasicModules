//
//  Geometric+Utils.swift
//  Pods
//
//  Created by 王强 on 2020/6/14.
//
#if canImport(CoreGraphics)
import CoreGraphics
public extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    } 
}

//public enum SizeFitMode {
//    /// 尺寸放大到内容尺寸
//    case fill
//    /// 按照大的边缩放
//    case aspectFit
//    // 按照小的边缩放
//    case aspectFill
//}

public extension CGSize { 
    /// 根据不同模式适配宽高比
    func aspectRatio(_ aspectRatio: CGSize, contentMode: UIView.ContentMode) -> CGRect {
        guard width*height != 0 && aspectRatio.height*aspectRatio.width != 0 else {
            return .zero
        }
        switch contentMode {
        case .scaleToFill:
            return CGRect(origin: .zero, size: aspectRatio)
        case .scaleAspectFit: //按照最小的比例居中
            let scaleW = aspectRatio.width/width
            let scaleH = aspectRatio.height/height
            let scale = min(scaleW, scaleH)
            let scaleSize = CGSize(width: width*scale, height: height*scale)
            let origin = CGPoint(x: (aspectRatio.width - scaleSize.width) * 0.5, y: (aspectRatio.height - scaleSize.height) * 0.5)
            return CGRect(origin: origin, size: scaleSize)
        case .scaleAspectFill: //按照最大的比例居中
            let scaleW = aspectRatio.width/width
            let scaleH = aspectRatio.height/height
            let scale = max(scaleW, scaleH)
            let scaleSize = CGSize(width: width*scale, height: height*scale)
            let origin = CGPoint(x: (aspectRatio.width - scaleSize.width) * 0.5, y: (aspectRatio.height - scaleSize.height) * 0.5)
            return CGRect(origin: origin, size: scaleSize)
        case .center:
            let origin = CGPoint(x: (aspectRatio.width - width) * 0.5, y: (aspectRatio.height - height) * 0.5)
            return CGRect(origin: origin, size: self)
        case .top:
            let origin = CGPoint(x: (aspectRatio.width - width) * 0.5, y: 0.0)
            return CGRect(origin: origin, size: self)
        case .bottom:
            let origin = CGPoint(x: (aspectRatio.width - width) * 0.5, y: aspectRatio.height - height)
            return CGRect(origin: origin, size: self)
        case .left:
            let origin = CGPoint(x: 0, y: (aspectRatio.height - height) * 0.5)
            return CGRect(origin: origin, size: self)
        case .right:
            let origin = CGPoint(x: aspectRatio.width - width, y: (aspectRatio.height - height) * 0.5)
            return CGRect(origin: origin, size: self)
        case .topLeft:
            return CGRect(origin: .zero, size: self)
        case .topRight:
            let origin = CGPoint(x: aspectRatio.width - width, y: 0.0)
            return CGRect(origin: origin, size: self)
        case .bottomLeft:
            let origin = CGPoint(x: 0.0, y: aspectRatio.height - height)
            return CGRect(origin: origin, size: self)
        case .bottomRight:
            let origin = CGPoint(x: aspectRatio.width - width, y: aspectRatio.height - height)
            return CGRect(origin: origin, size: self)
        default:
            return .zero
        }
    }
}
#endif
