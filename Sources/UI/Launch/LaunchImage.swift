//
//  LaunchImage.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/4/15.
//
// https://developer.apple.com/documentation/bundleresources/information_property_list/user_interface

import Foundation
import UIKit

open class LaunchImage: NSObject {
    
    static public var snapshotLaunch: UIImage? {
        guard let info = Bundle.main.infoDictionary else { return nil }
        if info.has(key: "UILaunchStoryboardName") {
            return launchScreenImage
        } else if info.has(key: "UILaunchImages") {
            return launchImage
        }
        return nil
    }
    /// Launch Asset Image
    static public var launchImage: UIImage? {
        guard let images = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] else {
            return nil
        }
        for dict in images {
            if let imgName = dict["UILaunchImageName"] as? String,
               let imgSizeStr = dict["UILaunchImageSize"] as? String {
                let imgSize = NSCoder.cgSize(for: imgSizeStr)
                    if UIScreen.main.bounds.size == imgSize {
                        return UIImage(named: imgName)
                    }
            }
        }
        return nil
    }
    static public var launchScreenImage: UIImage? {
        guard let launchStoryboardName = Bundle.main.infoDictionary?["UILaunchStoryboardName"] as? String else { return nil }
        assert(Bundle.main.path(forResource: launchStoryboardName, ofType: "nib") == nil, "启动屏截屏不支持xib格式")
         
        guard let launchViewController = UIStoryboard(name: launchStoryboardName, bundle: nil).instantiateInitialViewController(),
              let view = launchViewController.view else { return nil }
        // 加入到UIWindow后，LaunchScreenSb.view的safeAreaInsets在刘海屏机型才正常。
        let containerWindow = UIWindow(frame: UIScreen.main.bounds)
        view.frame = containerWindow.bounds 
        containerWindow.addSubview(view)
        containerWindow.layoutIfNeeded()
        containerWindow.isHidden = false
        let image = containerWindow.snapshot()
        containerWindow.isHidden = true
        return image
    }
}
