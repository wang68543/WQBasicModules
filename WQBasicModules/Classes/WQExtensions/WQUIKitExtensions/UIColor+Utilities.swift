//
//  UIColor+Utilities.swift
//  Pods
//
//  Created by hejinyin on 2018/3/19.
//

import UIKit

extension UIColor {
    //  swiftlint:disable identifier_name
   public convenience init(hex: UInt32) {
        let r = UInt8((hex & 0xff0000) >> 16)
        let g = UInt8((hex & 0x00ff00) >> 8)
        let b = UInt8(hex & 0x0000ff)
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
}
