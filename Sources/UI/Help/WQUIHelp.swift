//
//  WQUIHelp.swift
//  Pods
//
//  Created by WangQiang on 2019/1/14.
//

import Foundation

final public class WQUIHelp {

    public class func topVisibleViewController() -> UIViewController? {
        return UIWindow.topNormal?.rootViewController?.topVisible()
    }

    public class func topNavigationController() -> UINavigationController? {
        return UIWindow.topNormal?.rootViewController?.topNavigationController()
    }

}
