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
    func topNavigationController() -> UINavigationController? {
        return self.base.topNavigationController()
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
    /// 当前View是否可见
    var isViewVisible: Bool {
        return self.isViewLoaded && !self.view.isHidden && self.view.alpha > 0.01 && self.view.window != nil
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
        if let presented = self.presentedViewController,
        presented.isViewVisible {
            return presented.topVisible()
        }
        if let navgationController = self as? UINavigationController,
        navgationController.isViewVisible {
            return navgationController.visibleViewController?.topVisible()
        }
        if let tabBarController = self as? UITabBarController,
        tabBarController.isViewVisible {
            return tabBarController.selectedViewController?.topVisible()
        }
        return self.isViewVisible ? self : nil
    }

    func topNavigationController() -> UINavigationController? {
        if let presented = self.presentedViewController,
        presented.isViewVisible {
            return presented.topNavigationController()
        }
        if let tabBarController = self as? UITabBarController,
        tabBarController.isViewVisible {
           return tabBarController.selectedViewController?.topNavigationController()
        }
        if let navgationController = self as? UINavigationController,
        navgationController.isViewVisible {
            return navgationController
        }
        return nil
    }

}
