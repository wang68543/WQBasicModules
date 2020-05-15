//
//  UIButton+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/5/15.
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
           return objc_getAssociatedObject(self, ExtensionsAssociatedKeys.clickInterval) as? TimeInterval ?? 0
        }
    }
}
