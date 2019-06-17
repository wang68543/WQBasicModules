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
    let imageView: UIImageView = UIImageView(image: UIImage(named: "首页8"))
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        self.view.addSubview(button)
        button.setTitle("点击弹出", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(alertAction(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 200, width: 100, height: 50)
        imageView.frame = CGRect(x: 300, y: 300, width: 60, height: 60)
        self.view.addSubview(imageView)
    }
 
    @objc func alertAction(_ sender: UIButton) {
        imageView.fadeImage(UIImage(named: "loud_speaker"))
        let alertView = UIView()
        alertView.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        alertView.backgroundColor = UIColor.red
//        alertView.wm.alert()
//        alertView.wm.presentation?.isEnableTabBackgroundDismiss = true
//        alertView.wm.presentation?.interactionDissmissDirection = .down
//        alertView.wm.show(from: .bottom, show: .center)
        
        let initailItem = WQAnimatedItem.defaultViewBackground(UIColor.black.withAlphaComponent(0.5), initial: .clear)
        let item = WQAnimatedItem(container: alertView.frame.size, postionStyle: .left, bounceStyle: .bounceCenter)
        let animator = WQTransitioningAnimator(items: [item, initailItem])
        let presention = WQPresentationable(subView: alertView, animator: animator)
        presention.show(animated: true, in: nil, completion: nil)
        
         presention.isEnableTabBackgroundDismiss = true
        
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
