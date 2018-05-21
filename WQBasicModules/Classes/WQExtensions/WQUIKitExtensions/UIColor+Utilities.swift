//
//  UIColor+Utilities.swift
//  Pods
//
//  Created by hejinyin on 2018/3/19.
//

import UIKit
public extension UIColor {
    //  swiftlint:disable identifier_name
    convenience init(hex: UInt32) {
        let r = UInt8((hex & 0xff0000) >> 16)
        let g = UInt8((hex & 0x00ff00) >> 8)
        let b = UInt8(hex & 0x0000ff)
        self.init(R: CGFloat(r), G: CGFloat(g), B: CGFloat(b))
    }
   convenience init(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat = 1.0) {
        self.init(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: A)
    }
}
