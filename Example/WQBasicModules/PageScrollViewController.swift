//
//  PageScrollViewController.swift
//  WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2020/4/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class PageScrollViewController: UIViewController {

    var pageScroll: PageViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewController1 = UIViewController()
        viewController1.view.backgroundColor = .red
        let viewController2 = UIViewController()
        viewController2.view.backgroundColor = .green
        let viewController5 = UIViewController()
        viewController5.view.backgroundColor = .blue
        let viewController6 = UIViewController()
        viewController6.view.backgroundColor = .brown
        let viewController3 = UIViewController()
        viewController3.view.backgroundColor = .purple
        let viewController4 = UIViewController()
        viewController4.view.backgroundColor = .systemPink
        pageScroll = PageViewController([viewController1,viewController2,viewController3,viewController4,viewController5], frame: CGRect(x: 0, y: 100, width: Screen.width, height: Screen.height - 100))
        pageScroll?.add(toParent: self)
    }

}
