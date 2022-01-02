//
//  UIApplication+Extensions.swift
//  Pods-WQBasicModules_Example
//
//  Created by 王强 on 2022/1/2.
//

import Foundation
public extension UIApplication {
    /// 获取名称
    var appIconNames: [String]? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let files = primaryIcon["CFBundleIconFiles"] as? [String] else {
                  return nil
              }
        return files
    }
    /// appIcon的最后一个图片
    var appIcon: UIImage? {
        guard let iconName = appIconNames?.last else { return nil }
        return UIImage(named: iconName)
    }

}
