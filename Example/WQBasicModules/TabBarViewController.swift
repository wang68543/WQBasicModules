//
//  TabBarViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/1/15.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        debugPrint("重新布局了")
    }

}
