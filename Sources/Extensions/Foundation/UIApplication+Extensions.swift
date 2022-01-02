//
//  UIApplication+Extensions.swift
//  Pods-WQBasicModules_Example
//
//  Created by 王强 on 2022/1/2.
//

import Foundation
public extension UIApplication {
    /// 获取名称
    public var appIconNames:[String]? {
        guard let CFBundleIcons = self.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let CFBundlePrimaryIcon = CFBundleIcons["CFBundlePrimaryIcon"] as? [String: Any],
              let CFBundleIconFiles = CFBundlePrimaryIcon["CFBundleIconFiles"] as? [String] else {
                  return nil
              }
        return CFBundleIconFiles
    }
    ///appIcon的最后一个图片
    public var appIcon: UIImage? {
        guard let iconName = appIconNames?.last else { nil }
        return UIImage(named: iconName)
    }
    
}
