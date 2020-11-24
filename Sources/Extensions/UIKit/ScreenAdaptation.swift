//
//  ScreenAdaptation.swift
//  WaterMark
//
//  Created by iMacHuaSheng on 2020/7/3.
//  Copyright © 2020 iMacHuaSheng. All rights reserved.
//

import Foundation
/**
 手机型号               屏幕尺寸     屏幕密度     开发尺寸         像素尺寸        倍图
 5/5S/5c/SE           4.0 英寸    326 ppi    320*568 pt     640*1136 px     @2x
 6/6S/7/8             4.7 英寸    326 ppi    375*667 pt     750*1334 px     @2x
 6+/6S+/7+/8+         5.5 英寸    401 ppi    621*1104 pt    1242*2208 px    @3x
 X/XS/11 Pro          5.8 英寸    458 ppi    562*1218 pt    1125*2436 px    @3x
 XR/11                6.1 英寸    326 ppi    414*896 pt     828*1792 px     @2x
 XS Max/11 Pro Max    6.5 英寸    458 ppi    621*1344 pt    1242*2688 px    @3x
 */

public enum iDevice {
    case iPhone4s
    case iPhone5_5s_5c_SE
    case iPhone6_6s_7_8
    
    case iPhone6p_6sp_7p_8p
    
    case iPhoneX_XS_11Pro
    case iPhoneXR_11
    case iPhoneXSMax_11ProMax
}
public extension CGFloat {
    func rpx(_ adaptWidth: CGFloat = iDevice.iPhone6_6s_7_8.width) -> CGFloat {
        return UIScreen.main.bounds.width/adaptWidth*self
    }
    var px: CGFloat {
        return self/UIScreen.main.scale
    }
}
public extension Double {
    func rpx(_ adaptWidth: CGFloat = iDevice.iPhone6_6s_7_8.width) -> CGFloat {
        return CGFloat(self).rpx(adaptWidth)
    }
    var px: CGFloat {
        return CGFloat(self)/UIScreen.main.scale
    }
}
public extension Int {
    func rpx(_ adaptWidth: CGFloat = iDevice.iPhone6_6s_7_8.width) -> CGFloat {
        return CGFloat(self).rpx(adaptWidth)
    }
    var px: CGFloat {
        return CGFloat(self)/UIScreen.main.scale
    }
}
public extension Float {
    func rpx(_ adaptWidth: CGFloat = iDevice.iPhone6_6s_7_8.width) -> CGFloat {
        return CGFloat(self).rpx(adaptWidth)
    }
    var px: CGFloat {
        return CGFloat(self)/UIScreen.main.scale
    }
}
public extension iDevice {
    var width: CGFloat {
        switch self {
        case .iPhone4s:
            return 320
        case .iPhone5_5s_5c_SE:
            return 320
        case .iPhone6_6s_7_8:
            return 375
        case .iPhone6p_6sp_7p_8p:
            return 414
        case .iPhoneX_XS_11Pro:
            return 375
        case .iPhoneXR_11:
            return 414
        case .iPhoneXSMax_11ProMax:
            return 414
        }
//        switch self {
//        case .iPhone4s:
//            return 640
//        case .iPhone5_5s_5c_SE:
//            return 640
//        case .iPhone6_6s_7_8:
//            return 750
//        case .iPhone6p_6sp_7p_8p:
//            return 1242
//        case .iPhoneX_XS_11Pro:
//            return 1125
//        case .iPhoneXR_11:
//            return 828
//        case .iPhoneXSMax_11ProMax:
//            return 1242
//        }
    }
}
