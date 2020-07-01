//
//  UIView+WQUIHelp.swift
//  Pods
//
//  Created by WangQiang on 2019/1/14.
//

import Foundation
/// 输入框类型
public typealias TextFieldView = UIView & UITextInput
public extension WQModules where Base: UIView {
//    var subtextFields: [textFieldView] {
//        return self.base.subtextFields
//    }
    var presenter: UIViewController? {
        return self.base.presenter
    }
}
extension UIView {
    /// 当前View所在的控制器
    var presenter: UIViewController? {
        var nextReponder: UIResponder? = self
        repeat {
            nextReponder = nextReponder?.next
            if nextReponder is UIViewController {
                if let tabBar = nextReponder as? UITabBarController {
                    return tabBar.selectedViewController
                } else if let nav = nextReponder as? UINavigationController {
                    return nav.topViewController
                }
                return nextReponder as? UIViewController
            }
        } while (nextReponder != nil)
        
        return nil
    }
    /// 获取控制器提前设置的keyboardManager
    public var keyboardManager: WQKeyboardManager? {
        return self.presenter?.keyboardManager
    }
}
extension UIView {
    /// 列出当前View的所有输入框
    var subtextFieldViews: [TextFieldView] {
        var inputViews: [TextFieldView] = []
        if let textField = self as? TextFieldView {
            inputViews.append(textField)
        } else if !self.subviews.isEmpty {
            let subs = self.subviews
            subs.forEach { view in
                inputViews.append(contentsOf: view.subtextFieldViews)
            }
        }
        return inputViews
    }
}
