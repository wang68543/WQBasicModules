//
//  Localize.swift
//  WQBasicModules
//
//  Created by 王强 on 2020/12/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
open class Localize {

    public static let shared = Localize()
    /// 是否是跟随App系统设置里面的语言
    public static var trackSystemLanguage: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: trackSystemLanguageKey)
            UserDefaults.standard.synchronize()
            Localize.shared.setCurrentBundle()
        }
        get {
            UserDefaults.standard.bool(forKey: trackSystemLanguageKey)
        }
    }
    /// 当多个区域使用类似的语言的时候 若当前App 需要使用的语言  App bundle 中午对应的 就找相似的 (例如 如果当前App 支持中文简体 但是App设置里面是繁体 当前属性为true 就会返回简体 否则返回默认)
    public var isFuzzyMatchLanguage: Bool = true
    
    init() {
        UserDefaults.standard.register(defaults: [Localize.trackSystemLanguageKey: true])
        setCurrentBundle()
        
    }
    /// 注册bundle
    open func register(_ bundleCls: AnyClass = LocalizeBundle.self) {
        object_setClass(Bundle.main, bundleCls)
    }
    
    public private(set) var currentBundle: Bundle?
   
    /// App 当前需要使用的语言
    public var currentLanguage: String {
        let availables = availableLanguages(true)
        let lan = Localize.trackSystemLanguage ? systemLanguage : userLanguage ?? defaultLanguage
        guard let language = lan,
              !availables.isEmpty else {
            return availables.first ?? "en"
        }
        guard !availables.contains(language) else {
            return language //可用的语言中包含当前语言
        }
        if self.isFuzzyMatchLanguage { // 模糊查找
            if let index = availables.firstIndex(where: {$0.hasPrefix(language)}) {
                return availables[index]
            } else if let index = availables.firstIndex(where: { Localize.isSame(lhs: $0, rhs: language, fuzzy: true) }) {
                return availables[index]
            }
        }
        return availables.first! // 所有的语言都没有 默认英文
    }
    /// 用户选择的语言(主要用于App内自己设置语言)
    public var userLanguage: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: Localize.userLanguageKey)
            UserDefaults.standard.synchronize()
            /// 禁止跟随系统语言
            Localize.trackSystemLanguage = false
        }
        get {
            UserDefaults.standard.string(forKey: Localize.userLanguageKey)
        }
    }
    
    /// 缺省语言 App内没有适配对应的语言的时候 取用
    public var defaultLanguage: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: Localize.defaultLanguageKey)
            UserDefaults.standard.synchronize()
            setCurrentBundle()
        }
        get {
            UserDefaults.standard.string(forKey: Localize.defaultLanguageKey)
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
public extension Localize {
    
    /// 查询当前是否是某个语言
    /// - Parameters:
    ///   - lan: 语言
    ///   - fuzzy: 是否是模糊匹配
    func matchCurrent(language lan: String, fuzzy: Bool = true) -> Bool {
        return Localize.isSame(lhs: lan, rhs: currentLanguage, fuzzy: fuzzy)
    }
}

public extension Localize {
    static func isSame(lhs: String, rhs: String, fuzzy: Bool) -> Bool {
        if fuzzy {
           return lhs.components(separatedBy: "-").first == rhs.components(separatedBy: "-").first
        } else {
            return lhs == rhs
        }
    }
}
/// - keys
private extension Localize {
    static let defaultLanguageKey = "UserLocalizeDefaultLanguage"
    static let userLanguageKey = "UserLocalizeLanguage"
    static let trackSystemLanguageKey = "LTrackSystemLanguage"
}
/// - Notification Name
public extension Localize {
    static let LLanguageDidChangeNotification = Notification.Name("LLanguageDidChangeNotification")
}
