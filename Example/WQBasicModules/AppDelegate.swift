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
//    @UserDefault("video", default: Video.default)
//    static var viedo: Video
    // curl -o .gitignore https://www.gitignore.io/api/swift 添加.gitignore
    //https://www.gitignore.io/api/objective-c
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        debugPrint("\(Int.max)")
        debugPrint("\(CGFloat.greatestFiniteMagnitude)")
        let example = ExampleViewController() 
        let nav = UINavigationController(rootViewController: example)
        example.view.backgroundColor = UIColor.white
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        testCodable()
        

//        debugPrint(<#T##items: Any...##Any#>)
//        TestWebViewController.uid = 1000
//        
//        debugPrint("=====\(TestWebViewController.uid)")
//        
//        debugPrint(AppDelegate.viedo.title)
        return true
    }
    
    
   

    func testCodable() {
        let json = #"{"id": 12345, "title": "My First Video", "state": "reversed"}"#
//        let value = try! JSONDecoder().decode(Video.self, from: json.data(using: .utf8)!)
        let value = try! Video.model(from: json.data(using: .utf8)!)
        
    }

}
struct Video: Codable {
    enum State: String, Codable, CodableDefaultValue {
        case streaming
        case archived
        case unknown
        
        static let defaultValue = Video.State.unknown
    }
    @CodableDefault.IntOne var id: Int
    @CodableDefault.Empty var title: String
    @CodableDefault.False var commentEnabled: Bool
    @CodableDefault.True var publicVideo: Bool

    @CodableDefault<State> var state: State
    
}
extension Video {
    static let `default` = Video(id: 111, title: "test", commentEnabled: false, publicVideo: false, state: .archived)
}
