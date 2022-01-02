//
//  UIWindow+Extension.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/4/22.
//

#if canImport(UIKit) && !os(watchOS)
import Foundation
import UIKit
public extension UIWindow {
    final class var topNormal: UIWindow? {
        let app = UIApplication.shared
        #if targetEnvironment(macCatalyst) // macOS
        var topWindow = app.windows.last
        #else
        var topWindow = app.keyWindow
        #endif
        topWindow = topWindow ?? app.delegate?.window ?? app.windows.last(where: { $0.windowLevel == .normal })
        return topWindow
    }

    final class var keyWindow: UIWindow? {
        let app = UIApplication.shared
        #if targetEnvironment(macCatalyst) // macOS
        return app.windows.last
        #else
        return app.keyWindow
        #endif
    }
    final var topViewController: UIViewController? {
        return self.rootViewController?.topVisible()
    }
    final var topNavigationController: UINavigationController? {
        return self.rootViewController?.topNavigationController()
    }
}
// show
public extension UIWindow {
    convenience init(frame: CGRect = UIScreen.main.bounds, _ viewController: UIViewController?) {
        self.init(frame: frame)
        self.isHidden = false
        self.backgroundColor = .clear
        self.alpha = 1
        self.rootViewController = viewController
    }
    func removeFromApplication() {
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.isHidden = true
    }
}

public func wm_topNavigationController() -> UINavigationController? {
    return UIWindow.topNormal?.topNavigationController
}

public func wm_topVisibleViewController() -> UIViewController? {
    return UIWindow.topNormal?.topViewController
}
#endif
