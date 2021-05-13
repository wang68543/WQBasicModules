//
//  LaunchImage.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/4/15.
//
// https://developer.apple.com/documentation/bundleresources/information_property_list/user_interface

import Foundation
import UIKit

open class LaunchScreen: NSObject { 
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
        let launchView = launchFullScreenView
        // 加入到UIWindow后，LaunchScreenSb.view的safeAreaInsets在刘海屏机型才正常。
        let containerWindow = UIWindow(frame: UIScreen.main.bounds)
        launchView.frame = containerWindow.bounds
        containerWindow.addSubview(launchView)
        containerWindow.layoutIfNeeded()
        containerWindow.isHidden = false
        let image = containerWindow.snapshot()
        containerWindow.isHidden = true
        return image
    }
    /// 获取启动的View
    static public var launchFullScreenView: UIView {
        guard let launchFileName = Bundle.main.infoDictionary?["UILaunchStoryboardName"] as? String else { fatalError("未获取到正确的启动文件,请确认是否配置了Launch Screen File") }
        let launchView: UIView
        if Bundle.main.path(forResource: launchFileName, ofType: "nib") != nil {//xib格式的启动文件
            let nib = UINib(nibName: launchFileName, bundle: nil)
            let views = nib.instantiate(withOwner: nil, options: nil)
            if let view = views.first as? UIView {
                launchView = view
            } else {
                fatalError("未获取到Launch Screen.xib的view")
            }
        } else if let launchViewController = UIStoryboard(name: launchFileName, bundle: nil).instantiateInitialViewController(),
        let view = launchViewController.view {
            launchView = view
        } else {
            fatalError("未获取到Launch Screen.storyboard的View")
        }
        return launchView
    }
}
