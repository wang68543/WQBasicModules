//
//  WQUIHelp.swift
//  Pods
//
//  Created by WangQiang on 2019/1/14.
//

import Foundation


final public class WQUIHelp {
    public class func topVisibleViewController() -> UIViewController? {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            return rootViewController.topVisible()
        }
    return UIApplication.shared.keyWindow?.rootViewController?.topVisible()
    }
    
    public class func topNavigationController() -> UINavigationController? {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            return rootViewController.topNavigationController()
        }
        return UIApplication.shared.keyWindow?.rootViewController?.topNavigationController()
    }
}

public func wm_topNavigationController() -> UINavigationController? {
    return WQUIHelp.topNavigationController()
}

public func wm_topVisibleViewController() -> UIViewController? {
    return WQUIHelp.topVisibleViewController()
}
