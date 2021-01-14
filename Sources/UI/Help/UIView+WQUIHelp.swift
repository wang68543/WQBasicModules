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
 
    var viewController: UIViewController? {
        return self.base.viewController
    }
}
extension UIView {
    var viewController: UIViewController? {
        var topResponser: UIResponder = self
        while let nextResponser = topResponser.next {
            if let window = nextResponser as? UIWindow {
                return window.rootViewController
            } else if nextResponser is UIView {
                topResponser = nextResponser
            } else if let controller = nextResponser as? UIViewController {
                return controller
            } else {
                return nil
            }
        }
        if let window = self as? UIWindow {
            return window.rootViewController
        } else {
            return nil
        } 
    }
    /// 获取控制器提前设置的keyboardManager
    public var keyboardManager: WQKeyboardManager? {
        return self.viewController?.keyboardManager
    }
    /// 转为全局坐标
    public var frameConvertToFullScreen: CGRect {
        guard let fatherView = self.superview else {
            return .zero
        }
        return fatherView.convert(self.frame, to: nil)
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
