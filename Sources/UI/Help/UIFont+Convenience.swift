//
//  UIFont+Convenience.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2021/4/8.
//

import UIKit
public extension UIFont {
    /// PingFangSC-Regular
    class func pingFangSC(ofSize fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Regular", size: fontSize)
    }
    class func ultralightPingFangSC(ofSize fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Ultralight", size: fontSize)
    }
    class func thinPingFangSC(ofSize fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Thin", size: fontSize)
    }
    class func lightPingFangSC(ofSize fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Light", size: fontSize)
    }
    class func mediumPingFangSC(ofSize fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: fontSize)
    }
    class func semiboldPingFangSC(ofSize fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize)
    } 
}
