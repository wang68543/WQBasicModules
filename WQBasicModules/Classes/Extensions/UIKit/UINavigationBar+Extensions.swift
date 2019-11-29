//
//  UINavigationBar+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/11/28.
//

import Foundation
public extension UINavigationBar {
    var isHiddenShadow: Bool {
        set {
            self.setValue(newValue, forKey: "hidesShadow")
        }
        get {
            return (self.value(forKey: "hidesShadow") as? Bool) ?? false 
        }
    }
}
