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
//        imageView.image = UIImage(linearGradient: [UIColor.red.cgColor, UIColor.green.cgColor], size: CGSize(width: 60, height: 60), startPoint: CGPoint(x: 1, y: 1), endPoint: CGPoint(x: 0, y: 1), locations: nil)
        imageView.image = UIImage(radialGradient: [UIColor.red.cgColor, UIColor.clear.cgColor], size: CGSize(width: 60, height: 60), startCenter: CGPoint(x: 0.5, y: 0.5), startRaidus: 0, endCenter: CGPoint(x: 0.5, y: 0.5), endRaidus: 60, options: .drawsAfterEndLocation)
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
    }
 
    @objc func alertAction(_ sender: UIButton) {
        imageView.fadeImage(UIImage(named: "loud_speaker"))
        let alertView = UIView()
        let size = CGSize(width: 200, height: 300)
//        alertView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        alertView.backgroundColor = UIColor.red
//        alertView.wm.alert()
//        alertView.wm.presentation?.isEnableTabBackgroundDismiss = true
//        alertView.wm.presentation?.interactionDissmissDirection = .down
//        alertView.wm.show(from: .bottom, show: .center)
        
//        let initailItem = WQAnimatedItem.defaultViewBackground(UIColor.black.withAlphaComponent(0.5), initial: .clear)
//        let item = WQAnimatedItem(container: alertView.frame.size, postionStyle: .left, bounceStyle: .bounceCenter)
//        let animator = WQTransitioningAnimator(items: [item, initailItem])
        let presentedFrame = UIScreen.main.bounds
        let dismiss = CGRect(x: (presentedFrame.width - size.width) * 0.5, y: presentedFrame.height * 0.5, width: size.width, height: 0)
       
        let show = CGRect(x: (presentedFrame.width - size.width) * 0.5, y: (presentedFrame.height - size.height) * 0.5, width: size.width, height: size.height)
        
        let items = Array(default: WQAnimatedItem(containerFrame: dismiss, show: show, dismiss: dismiss), viewFrame: presentedFrame)
        let animator = WQTransitionAnimator(items: items)
        
        let presention = WQTransitionable(subView: alertView, animator: animator)
        presention.show(animated: true, in: nil, completion: nil)
        presention.interactionDismissDirection = .down
         presention.tapDimmingViewDismissable = true
        
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
