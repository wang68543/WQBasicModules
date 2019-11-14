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
        return UIApplication.shared.keyWindow?.rootViewController
    } 
}
