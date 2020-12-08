//
//  UINavigationBar+Style.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/12/8.
//
#if canImport(UIKit) && !os(watchOS)
import Foundation

public struct UINavigationBarStyle: RawRepresentable, Equatable {
    public typealias RawValue = String
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    } 
}
public extension UINavigationBarStyle {
    static let none = UINavigationBarStyle(rawValue: "none")
    /// 透明
    static let translucent = UINavigationBarStyle(rawValue: "translucent")
}

public extension UINavigationBar {
    private struct AssociatedKeys {
       static let styleRawValue = UnsafeRawPointer(bitPattern: "wq.navigationBar.styleRawValue".hashValue)!
    }
    /// 隐藏导航栏 KVC
    var isHiddenShadow: Bool {
        set {
            if let value = value(forKey: "hidesShadow") as? Bool,
              value != newValue {
                self.setValue(newValue, forKey: "hidesShadow")
            }
        }
        get {
            return (self.value(forKey: "hidesShadow") as? Bool) ?? false
        }
    }
    
    /// 用于 保存当前UINavigationBar 的自定义风格 便于比较
    var style: UINavigationBarStyle {
        set {
            let oldValue = objc_getAssociatedObject(self, AssociatedKeys.styleRawValue) as? UINavigationBarStyle ?? .none
            guard oldValue != newValue else { return }
            if newValue == .translucent {
                self.makeTransparent()
            }
            objc_setAssociatedObject(self, AssociatedKeys.styleRawValue, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, AssociatedKeys.styleRawValue) as? UINavigationBarStyle ?? .none
        }
    }
}
#endif
