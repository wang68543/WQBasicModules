//
//  PageContentViewController.swift
//  WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2020/12/17.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class PageContentViewController: UIViewController {

    var pageContentView: PageContentView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController1 = UIViewController()
        viewController1.view.backgroundColor = .red
        let viewController2 = UIViewController()
        viewController2.view.backgroundColor = .green
        let viewController5 = UIViewController()
        viewController5.view.backgroundColor = .blue
        let viewController6 = PageChildViewController()
//        viewController6.view.backgroundColor = .brown
        let viewController3 = UIViewController()
        viewController3.view.backgroundColor = .purple
        let viewController4 = UIViewController()
        viewController4.view.backgroundColor = .systemPink
        let conrollers = [viewController1, viewController2, viewController3, viewController4, viewController5, viewController6]
        pageContentView = PageContentView(conrollers, index: 0, orientation: .vertical)
        self.view.addSubview(pageContentView)
        self.addChild(pageContentView.pageController)
        
        
    } 
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pageContentView.frame = self.view.bounds
    }
}
