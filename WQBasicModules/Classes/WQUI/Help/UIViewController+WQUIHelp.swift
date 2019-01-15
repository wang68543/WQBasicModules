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
extension UIViewController {
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
