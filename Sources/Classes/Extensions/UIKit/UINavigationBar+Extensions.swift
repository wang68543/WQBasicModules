//
//  UINavigationBar+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/11/28.
//

import Foundation
public extension UINavigationBar {
    /// 隐藏导航栏 
    var isHiddenShadow: Bool {
        set {
            self.setValue(newValue, forKey: "hidesShadow")
        }
        get {
            return (self.value(forKey: "hidesShadow") as? Bool) ?? false 
        }
    }
}
