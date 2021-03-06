//
//  WQUIHelp.swift
//  Pods
//
//  Created by WangQiang on 2019/1/14.
//

import Foundation
public extension WQModules where Base: UIViewController {
    func topVisible() -> UIViewController? {
        return self.base.topVisible()
    }
}

private var keyboardManagerKey: Void?

extension UIViewController {
   public var keyboardManager: WQKeyboardManager? {
        set {
            objc_setAssociatedObject(self, &keyboardManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
           return objc_getAssociatedObject(self, &keyboardManagerKey) as? WQKeyboardManager
        }
    }

    @discardableResult
    public func enableKeyboardManager(_ enable: Bool) -> WQKeyboardManager? {
        if enable {
            if self.isViewLoaded {
                let mangager = WQKeyboardManager(self.view)
                self.keyboardManager = mangager
                return mangager
            } else {
                debugPrint("请在View加载之后使用")
                return nil
            }
        } else {
            self.keyboardManager?.isEnabled = false
        }
        return self.keyboardManager
    }

    func topVisible() -> UIViewController? {
        if self.presentedViewController != nil {
            return self.presentedViewController?.topVisible()
        }
        if let navgationController = self as? UINavigationController {
            return navgationController.visibleViewController?.topVisible()
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topVisible()
        }
        if !self.isViewLoaded {
            return nil
        }
        if !self.view.isHidden && self.view.alpha > 0.01 && self.view.window != nil {
             return self
        }
        return nil
    }
}
