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
        pageScroll = PageViewController([UIViewController(),UIViewController()], frame: CGRect(x: 0, y: 100, width: Screen.width, height: Screen.height - 100))
        pageScroll?.add(toParent: self)
    }

}
