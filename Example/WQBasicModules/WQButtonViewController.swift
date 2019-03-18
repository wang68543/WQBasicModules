//
//  WQButtonViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/3/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class WQButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let testBtn = TestButton()
        testBtn.setTitle("测试按钮", for: .normal)
        
        testBtn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        self.view.addSubview(testBtn)
        testBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        testBtn.setImage(UIImage(named: "首页6"), for: .normal)
        testBtn.setBackgroundImage(UIImage(named: "ADImage"), for: .normal)
        let btn = WQButton()
        btn.wq_setImageMasks(20)
        // Do any additional setup after loading the view.
    }
    
 

}
