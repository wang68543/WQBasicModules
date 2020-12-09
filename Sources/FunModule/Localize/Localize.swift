//
//  Localize.swift
//  WQBasicModules
//
//  Created by 王强 on 2020/12/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
open class Localize {
    private static let defaultLanguageKey = "UserLocalizeDefaultLanguage"
    private static let userLanguageKey = "UserLocalizeLanguage"
    public static let LLanguageDidChangeNotification = Notification.Name("LLanguageDidChangeNotification")
    static let shared = Localize()
    /// 是否是跟随App系统设置里面的语言
    public var trackSystemLanguage: Bool = false {
        didSet {
            setCurrentBundle()
        }
    }
    /// 当多个区域使用类似的语言的时候 若当前App 需要使用的语言  App bundle 中午对应的 就找相似的 (例如 如果当前App 支持中文简体 但是App设置里面是繁体 当前属性为true 就会返回简体 否则返回默认)
    public var isIngnoreRegionForUnkownLanguage: Bool = true
    
    init() {
        setCurrentBundle()
    }
    /// 注册bundle
    open func register(_ bundleCls: AnyClass = LocalizeBundle.self) {
        object_setClass(Bundle.main, bundleCls)
    }
    public private(set) var currentBundle: Bundle?
   
    /// App 当前需要使用的语言
    public var currentLanguage: String {
        let languages = availableLanguages(true)
        let language = trackSystemLanguage ? systemLanguage : userLanguage ?? defaultLanguage
        
        if self.isIngnoreRegionForUnkownLanguage { // 模糊查找
            if let lan = language {
                if languages.contains(lan) {
                    return lan
                } else if let index = languages.firstIndex(where: {$0.hasPrefix(lan)}) {
                    return languages[index]
                } else {
                    if let pre = lan.components(separatedBy: "-").first,
                       let index = languages.firstIndex(where: { $0.components(separatedBy: "-").first == pre }) {
                        return languages[index]
                    }
                }
            }
        } else {
            if let lan = language,
               languages.contains(lan) {
                return lan
            }
        }
        return languages.first ?? "en" // 所有的语言都没有 默认英文
    }
    /// 用户选择的语言(主要用于App内自己设置语言)
    public var userLanguage: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: Localize.userLanguageKey)
            UserDefaults.standard.synchronize()
            setCurrentBundle()
        }
        get {
            return UserDefaults.standard.string(forKey: Localize.userLanguageKey)
        }
    }
    
    /// 缺省语言
    public var defaultLanguage: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: Localize.defaultLanguageKey)
            UserDefaults.standard.synchronize()
            setCurrentBundle()
        }
        get {
            return UserDefaults.standard.string(forKey: Localize.defaultLanguageKey)
        }
    }
    /// 系统当前的语言(iOS13以前) 或者设置里面对应的App的语言(iOS13之后)
    public var systemLanguage: String? {
        return Bundle.main.preferredLocalizations.first
    }
   
    private func setCurrentBundle() {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") else{
            return
        }
        currentBundle = Bundle(path: path)
    }
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    /// 语言在不同语言下显示的名字
    open func displayNameForLanguage(_ language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage)
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
}
