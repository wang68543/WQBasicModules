//
//  AppDelegate.swift
//  WQBasicModules
//
//  Created by tangtangmang@163.com on 01/21/2018.
//  Copyright (c) 2018 tangtangmang@163.com. All rights reserved.
//  swiftlint:disable line_length

import UIKit
import WQBasicModules
import AdSupport
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let example = ExampleViewController()
          let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
         let idfv = UIDevice.current.identifierForVendor?.uuidString
        debugPrint("idfa:\(idfa)")
         debugPrint("idfv:\(idfv)")
 
        
        // xMax
        //不允许追踪
        //"idfa:00000000-0000-0000-0000-000000000000"
        //"idfv:Optional(\"D5EDFCD7-49D0-4A3B-83F4-761759FE92C1\")"
        //允许追踪
        //"idfa:6E4DDA21-AD14-450F-9A7E-56F2CFE4C664"
        //"idfv:Optional(\"D5EDFCD7-49D0-4A3B-83F4-761759FE92C1\")"
        //不允许追踪
        //"idfa:00000000-0000-0000-0000-000000000000"
        //"idfv:Optional(\"D5EDFCD7-49D0-4A3B-83F4-761759FE92C1\")"
        
        // 允许追踪
        //"idfa:C62B9DBC-80EC-4BEA-AD4C-D69F19A6A4D8"
        // "idfv:Optional(\"D5EDFCD7-49D0-4A3B-83F4-761759FE92C1\")"
        
        // 删除重新安装
        //"idfa:C62B9DBC-80EC-4BEA-AD4C-D69F19A6A4D8"
        //"idfv:Optional(\"D5EDFCD7-49D0-4A3B-83F4-761759FE92C1\")"
        
        //"idfa:38198E5B-028B-4E7B-B01E-1621E0CCA3A4"
        //"idfv:Optional(\"6C4BF1AA-3415-45DE-9D5F-E8C643CF2FA7\")"
        
        
       // "idfa:38198E5B-028B-4E7B-B01E-1621E0CCA3A4"
        // "idfv:Optional(\"467F8F15-0825-45B7-8180-3F04061E3A1E\")"
        
        // iphone7 10.3.1
        //开
       // "idfa:08A7D1EC-2397-4078-B003-EDD9BC1C9296"
        // "idfv:Optional(\"5C85F113-F7E2-4907-B7BB-B26809E3C5D7\")"
        // 关
        //"idfa:2354652D-536D-43D1-91C3-31FBC27CAC83"
        //"idfv:Optional(\"5C85F113-F7E2-4907-B7BB-B26809E3C5D7\")"
        //开
        //"idfa:6895D2F7-2368-4DEB-AE02-EF33B05CF506"
        //"idfv:Optional(\"5C85F113-F7E2-4907-B7BB-B26809E3C5D7\")"
        
        // 删除重装
        //"idfa:6895D2F7-2368-4DEB-AE02-EF33B05CF506"
        //"idfv:Optional(\"D89B3028-AE20-4203-A48A-16896E1C9137\")"
        // 重置
        //"idfa:6524093C-E44E-48FF-ABDD-8E0CE6ADA503"
        //"idfv:Optional(\"D89B3028-AE20-4203-A48A-16896E1C9137\")"
        
        // iphone8 11.0.1
        // 开
        // "idfa:26A09676-EACF-4A48-AF0A-71AA470041EF"
        // "idfv:Optional(\"9CC57521-1FD5-4E91-8B34-644BE195EC48\")"
        //关
        //"idfa:C53543E8-B138-4533-A7C4-C17189CE859C"
        //"idfv:Optional(\"9CC57521-1FD5-4E91-8B34-644BE195EC48\")"
        //开
        //"idfa:08667975-E46E-4D24-8608-3F12A415490C"
        //"idfv:Optional(\"9CC57521-1FD5-4E91-8B34-644BE195EC48\")"
        
        //重置
        //"idfa:3331B655-A1FB-466B-AFF4-BE39271EB42D"
        //"idfv:Optional(\"9CC57521-1FD5-4E91-8B34-644BE195EC48\")"
        
        //删除重装
        // "idfa:3331B655-A1FB-466B-AFF4-BE39271EB42D"
        //"idfv:Optional(\"9CC57521-1FD5-4E91-8B34-644BE195EC48\")"
       
        
        
        // iphone6 iOS 9.1
        
        //开
        //"idfa:AF1123CA-ABAA-4696-B169-4FA0A39C3043"
        // "idfv:Optional(\"6EEB9A56-681E-401F-B186-2FE29A910D80\")"
        //关
        //"idfa:9EBA9DE1-282F-4365-B45F-2FD6D73BED0A"
        //"idfv:Optional(\"6EEB9A56-681E-401F-B186-2FE29A910D80\")"
        
        //开
        //"idfa:8E0005D4-0EC2-4B4F-B6AE-4667FFBC58F3"
//        "idfv:Optional(\"6EEB9A56-681E-401F-B186-2FE29A910D80\")"
        
        //重置
        //"idfa:AD43AFC5-1591-47DF-B11C-DFFF1EDB26C4"
        //"idfv:Optional(\"6EEB9A56-681E-401F-B186-2FE29A910D80\")"
        
        //删除重装
        //"idfa:AD43AFC5-1591-47DF-B11C-DFFF1EDB26C4"
        //"idfv:Optional(\"6EEB9A56-681E-401F-B186-2FE29A910D80\")"
        //删除重装
        //"idfa:AD43AFC5-1591-47DF-B11C-DFFF1EDB26C4"
        //"idfv:Optional(\"6EEB9A56-681E-401F-B186-2FE29A910D80\")"
        
        //"idfa:AD43AFC5-1591-47DF-B11C-DFFF1EDB26C4"
        // "idfv:Optional(\"30D749C7-F33B-4058-930C-1DD6F118F89A\")"
        let nav = UINavigationController(rootViewController: example)
        example.view.backgroundColor = UIColor.white
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible() 
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        debugPrint(WQDateFormatter.sharedDateFormater)
     
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
