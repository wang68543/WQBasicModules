//
//  UINavigationBar+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/11/28.
//
#if canImport(UIKit) && !os(watchOS)
import Foundation
public extension UINavigationBar {
    struct AssociatedKeys {
       static let styleRawValue = UnsafeRawPointer(bitPattern: "wq.navigationBar.maxInputLength".hashValue)!
    }
    /// 隐藏导航栏 KVC
    var isHiddenShadow: Bool {
        set {
            self.setValue(newValue, forKey: "hidesShadow")
        }
        get {
            return (self.value(forKey: "hidesShadow") as? Bool) ?? false 
        }
    }
    
    /// 用于 保存当前UINavigationBar 的自定义风格 便于比较
    var styleRawValue: Int {
        set {
            objc_setAssociatedObject(self, AssociatedKeys.styleRawValue, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            objc_getAssociatedObject(self, AssociatedKeys.styleRawValue) as? Int ?? -1
        }
    }
}

// MARK: - Methods
public extension UINavigationBar {

    /// SwifterSwift: Set Navigation Bar title, title color and font.
    ///
    /// - Parameters:
    ///   - font: title font
    ///   - color: title text color (default is .black).
    func setTitleFont(_ font: UIFont, color: UIColor = .black) {
        var attrs = [NSAttributedString.Key: Any]()
        attrs[.font] = font
        attrs[.foregroundColor] = color
        titleTextAttributes = attrs
    }

    /// SwifterSwift: Make navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func makeTransparent(withTint tint: UIColor = .white) {
        isTranslucent = true
        backgroundColor = .clear
        barTintColor = .clear
        setBackgroundImage(UIImage(), for: .default)
        tintColor = tint
        titleTextAttributes = [.foregroundColor: tint]
        shadowImage = UIImage()
    }

    /// SwifterSwift: Set navigationBar background and text colors
    ///
    /// - Parameters:
    ///   - background: backgound color
    ///   - text: text color
    func setColors(background: UIColor, text: UIColor) {
        isTranslucent = false
        backgroundColor = background
        barTintColor = background
        setBackgroundImage(UIImage(), for: .default)
        tintColor = text
        titleTextAttributes = [.foregroundColor: text]
    }

}
#endif
