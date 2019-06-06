//
//  ExampleAlertViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/3/7.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class ExampleAlertViewController: BaseExampleViewController {
    let alertView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        self.view.addSubview(button)
        button.setTitle("点击弹出", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(alertAction(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
    }
 
    @objc func alertAction(_ sender: UIButton) {
        
        let alertView = UIView()
        alertView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
        alertView.backgroundColor = UIColor.red
        alertView.wm.alert()
//        alertView.wm.presentation?.isEnableTabBackgroundDismiss = true
        alertView.wm.presentation?.interactionDissmissDirection = .down
//        alertView.wm.show(from: .bottom, show: .center)
        
//        let alertView = WQAlertView("测试", message: "测试内ring我问问无萨达")
//        alertView.addAction(WQAlertAction(title: "取消", handler: { action in
//
//        }))
//        alertView.addAction(WQAlertAction(title: "确认", handler: { action in
//
//        }))
//        alertView.show()
    }

}
