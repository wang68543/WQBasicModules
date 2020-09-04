//
//  TabBarViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/1/15.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame: ReferenceWritableKeyPath<WQLayoutContainerViewController, CGRect> = \WQLayoutContainerViewController.containerView.frame
        let backgroundColor: ReferenceWritableKeyPath<UIViewController, UIColor?> = \UIViewController.view!.backgroundColor 
        
        let viewController = WQLayoutContainerViewController()
        viewController[keyPath: frame] = CGRect.zero
        viewController[keyPath: backgroundColor] = UIColor.clear
        
//        viewController[keyPath: name]
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        debugPrint("重新布局了")
    }

}
