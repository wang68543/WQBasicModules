//
//  UIApplication+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/6/21.
//

import Foundation
public extension UIApplication {

    /// SwifterSwift: Application name (if applicable).
    var displayName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }

    /// SwifterSwift: App current build number (if applicable).
    var buildNumber: String? {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
    }

    /// SwifterSwift: App's current version number (if applicable).
    var version: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
