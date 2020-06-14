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
#endif
