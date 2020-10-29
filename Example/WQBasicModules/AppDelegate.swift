//
//  AppDelegate.swift
//  WQBasicModules
//
//  Created by tangtangmang@163.com on 01/21/2018.
//  Copyright (c) 2018 tangtangmang@163.com. All rights reserved.
//  swiftlint:disable line_length

import UIKit
import WQBasicModules
import CoreLocation

// Swift宏定义
// https://www.cnblogs.com/sundaysme/p/11933754.html
// https://www.macbed.com/navicat-premium/ 软件地址
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    // curl -o .gitignore https://www.gitignore.io/api/swift 添加.gitignore
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        debugPrint("\(Int.max)")
        debugPrint("\(CGFloat.greatestFiniteMagnitude)")
        let example = ExampleViewController() 
        let nav = UINavigationController(rootViewController: example)
        example.view.backgroundColor = UIColor.white
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }

}
