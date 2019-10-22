//
//  Screen.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/2/22.
//

import Foundation
import UIKit
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
    
    /// 屏幕的 周边限制显示区域
    public static var safeAreaInsets: UIEdgeInsets = {
        var instets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *),
          let window = UIApplication.shared.delegate?.window ?? UIApplication.shared.windows.last {
            instets = window.safeAreaInsets
            if window.safeAreaInsets.top == 0 || window.safeAreaInsets.bottom == 0 {
                if UIScreen.main.bounds.height >= 812 {
                    if instets.top == 0 { instets.top = 44 }
                    if instets.bottom == 0 { instets.bottom = 34 }
                }
            }
//            UIApplication.didChangeStatusBarFrameNotification
//            UIApplicationDidChangeStatusBarFrameNotification
        }
        return instets
    }()
    
    func didChangeStatusBarFrame(_ note: Notification) {
        
    }
}
