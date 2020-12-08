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
    static var trackSystemLanguage: Bool = false
    
    //object_setClass(Bundle.main, LanguageBundle.self)
    
    /// 用户选择的语言(主要用于App内自己设置语言)
    public static var userLanguage: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userLanguageKey)
            UserDefaults.standard.synchronize()
            setCurrentBundle()
        }
        get {
            return UserDefaults.standard.string(forKey: userLanguageKey)
        }
    }
    
    /// 缺省语言
    public static var defaultLanguage: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: defaultLanguageKey)
            UserDefaults.standard.synchronize()
            setCurrentBundle()
        }
        get {
            return UserDefaults.standard.string(forKey: defaultLanguageKey)
        }
    }
    /// 系统当前的语言(iOS13以前) 或者设置里面对应的App的语言(iOS13之后)
    static var systemLanguage: String? {
        return Bundle.main.preferredLocalizations.first
    }
    /// App 当前需要使用的语言
    static var currentLanguage: String {
        let languages = availableLanguages(true)
        let language = trackSystemLanguage ? systemLanguage : userLanguage ?? defaultLanguage
        if let lan = language,
           languages.contains(lan) {
            return lan
        }
        return languages.first ?? "en" // 所有的语言都没有 默认英文
    }
    static func setCurrentBundle() {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") else{
            return
        }
        currentBundle = Bundle(path: path)
    }
    internal static var currentBundle: Bundle? = {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") else{
            return nil
        }
        return Bundle(path: path)
    }()
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    open class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    
//    static var currentLanguage: String {
//        set {
//            
//        }
//        get {
//            
//        }
//    }
//    /**
//     Current language
//     - Returns: The current language. String.
//     */
//    open class func currentLanguage() -> String {
//        if let currentLanguage = UserDefaults.standard.object(forKey: LCLCurrentLanguageKey) as? String {
//            return currentLanguage
//        }
//        return defaultLanguage()
//    }
//    
//    /**
//     Change the current language
//     - Parameter language: Desired language.
//     */
//    open class func setCurrentLanguage(_ language: String) {
//        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
//        if (selectedLanguage != currentLanguage()){
//            UserDefaults.standard.set(selectedLanguage, forKey: LCLCurrentLanguageKey)
//            UserDefaults.standard.synchronize()
//            NotificationCenter.default.post(name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
//        }
//    }
//    
//    /**
//     Default language
//     - Returns: The app's default language. String.
//     */
//    open class func defaultLanguage() -> String {
//        var defaultLanguage: String = String()
//        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
//            return LCLDefaultLanguage
//        }
//        let availableLanguages: [String] = self.availableLanguages()
//        if (availableLanguages.contains(preferredLanguage)) {
//            defaultLanguage = preferredLanguage
//        }
//        else {
//            defaultLanguage = LCLDefaultLanguage
//        }
//        return defaultLanguage
//    }
}
