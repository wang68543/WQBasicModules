//
//  UIDevice+Extensions.swift
//  HandMetroSwift
//
//  Created by WQ on 2019/6/11.
//

import Foundation

public extension UIDevice {
    // iPhone 6sPlus -> iPhone8,2
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8,
                value != 0 else {
                    return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        } 
    }
}
