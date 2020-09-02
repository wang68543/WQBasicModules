//
//  WQUIHelp.swift
//  Pods
//
//  Created by WangQiang on 2019/1/14.
//

import Foundation

final public class WQUIHelp {
    class func topNormalWindow() -> UIWindow? {
        let app = UIApplication.shared
        var topWindow: UIWindow?
        if let mainWindow = app.delegate?.window {
            topWindow = mainWindow
        }
        if topWindow == nil {
            topWindow = app.windows.last(where: { $0.windowLevel == .normal })
        }
        return topWindow
    }
     
    public class func topVisibleViewController() -> UIViewController? {
        return topNormalWindow()?.rootViewController?.topVisible()
    }
    
    public class func topNavigationController() -> UINavigationController? {
        return topNormalWindow()?.rootViewController?.topNavigationController()
    }
    
}

public func wm_topNavigationController() -> UINavigationController? {
    return WQUIHelp.topNavigationController()
}

public func wm_topVisibleViewController() -> UIViewController? {
    return WQUIHelp.topVisibleViewController()
}
