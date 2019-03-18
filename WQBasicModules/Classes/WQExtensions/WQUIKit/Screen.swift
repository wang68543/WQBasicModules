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
}
