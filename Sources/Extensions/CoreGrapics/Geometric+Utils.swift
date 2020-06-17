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

public enum SizeFitMode {
    /// 尺寸放大到内容尺寸
    case fill
    /// 按照大的边缩放
    case aspectFit
    // 按照小的边缩放
    case aspectFill
}

public extension CGSize {
    func fit(to targetSize: CGSize, contentMode: SizeFitMode = .aspectFit) -> CGSize {
        var fixSize: CGSize
        switch contentMode {
        case .fill:
            fixSize = targetSize
        case .aspectFill:
            let scaleW = targetSize.width/self.width
            let scaleH = targetSize.height/self.height
            let scale = max(scaleW, scaleH)
            fixSize = CGSize(width: self.width * scale, height: self.height * scale)
        case .aspectFit:
            let scaleW = targetSize.width/self.width
            let scaleH = targetSize.height/self.height
            let scale = min(scaleW, scaleH)
            fixSize = CGSize(width: self.width * scale, height: self.height * scale)
            
        }
        return fixSize
    }
}
#endif
