//
//  UIButton+Extensions.swift
//  Pods
//
//  Created by WQ on 2020/5/15.
//

import UIKit
import Foundation
public extension UIButton {
     private struct ExtensionsAssociatedKeys {
           static let clickInterval = UnsafeRawPointer(bitPattern: "wq.button.Extensions.clickInterval".hashValue)!
       }
    var clickInterval: TimeInterval {
        set {
            objc_setAssociatedObject(self, ExtensionsAssociatedKeys.clickInterval, newValue, .OBJC_ASSOCIATION_ASSIGN) 
        }
        get {
            objc_getAssociatedObject(self, ExtensionsAssociatedKeys.clickInterval) as? TimeInterval ?? 0
        }
    }
    /// 便捷的设置button的标题
    func setTitle(_ title: String, font: UIFont?, color: UIColor, state: UIControl.State) {
        var options: [NSAttributedString.Key: Any] = [:]
        options[.font] = font
        options[.foregroundColor] = color
        let attribute = NSAttributedString(string: title, attributes: options)
        setAttributedTitle(attribute, for: state)
    }
}
