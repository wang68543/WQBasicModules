//
//  UIApplication+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/6/21.
//
import Foundation
public extension UIApplication {
    /// SwifterSwift: Application running environment.
    ///
    /// - debug: Application is running in debug mode.
    /// - testFlight: Application is installed from Test Flight.
    /// - appStore: Application is installed from the App Store.
    enum Environment {
        case debug
        case testFlight
        case appStore
    }
    
    /// SwifterSwift: Current inferred app environment.
    var inferredEnvironment: Environment {
        #if DEBUG
        return .debug
        
        #elseif targetEnvironment(simulator)
        return .debug
        
        #else
        if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        }
        
        guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
            return .debug
        }
        
        if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
            return .testFlight
        }
        
        if appStoreReceiptUrl.path.lowercased().contains("simulator") {
            return .debug
        }
        
        return .appStore
        #endif
    }
    /// SwifterSwift: Application name (if applicable).
    var displayName: String? {
        guard let info = Bundle.main.infoDictionary else { return nil }
        return (info["CFBundleDisplayName"] as? String) ?? info[kCFBundleNameKey as String] as? String 
    }
    
    /// SwifterSwift: App current build number (if applicable).
    var buildNumber: String? {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String
    }
    
    /// https://www.hangge.com/blog/cache/detail_1793.html (动态设置启动页的版本号)
    /// SwifterSwift: App's current version number (if applicable).
    var version: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? String() 
    }
} 
