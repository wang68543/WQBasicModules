//
//  CGFloatExtension.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2021/3/4.
//

#if canImport(CoreGraphics)
import CoreGraphics

#if canImport(Foundation)
import Foundation
#endif

public extension CGFloat {
    var degreesToRadians: CGFloat {
        return .pi * self / 180.0
    }
    var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
    var abs: CGFloat {
        return Swift.abs(self)
    }
    
    #if canImport(Foundation)
    var ceil: CGFloat {
        return Foundation.ceil(self)
    }
    
    var floor: CGFloat {
        return Foundation.floor(self)
    }
    #endif
}
#endif
