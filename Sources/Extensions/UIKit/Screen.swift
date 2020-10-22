//
//  Screen.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/2/22.
//
import Foundation
#if canImport(UIKit)
//#if canUse(UIApplication)
//#if os(iOS)
//#if targetEnvironment(iOSApplicationExtension)
import UIKit
@available(iOSApplicationExtension, unavailable)
public struct Screen {
    public static let bounds = UIScreen.main.bounds
    public static let size = UIScreen.main.bounds.size
    public static let scale = UIScreen.main.scale
    public static let width = UIScreen.main.bounds.width
    public static let height = UIScreen.main.bounds.height
    /// 1像素线条的宽度
    public static let lineWidth = 1 / UIScreen.main.scale
    /// 绘制1像素线条时候的偏移
    public static let lineAdjustOffset = (1 / UIScreen.main.scale) / 2
    
    /// 屏幕的 周边限制显示区域 (因为这里在非刘海屏上面首次) 
    public static let safeAreaInsets: UIEdgeInsets = {
        var instets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, tvOS 11.0, *) {
            #if targetEnvironment(macCatalyst)
            let win = UIApplication.shared.windows.last
            #else
            let win = UIApplication.shared.keyWindow
            #endif
            /// 12 Pro Max/12 Pro/12 top: 47, 12 Mini top: 50
            if let window = UIApplication.shared.delegate?.window ?? win {
                instets = window.safeAreaInsets
                if instets.top == 0 {
                    if instets.bottom > 0 { //刘海屏
                        instets.top = max(44.0, UIApplication.shared.statusBarFrame.height)
                    } else {
                        instets.top = max(20.0, UIApplication.shared.statusBarFrame.height)
                    }
                }
            }
        } else {
            instets.top = 20.0
        }
        return instets
    }()
}
#endif
