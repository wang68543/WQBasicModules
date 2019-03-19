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
        testBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(testBtn)
//        testBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        testBtn.setImage(UIImage(named: "首页6"), for: .normal)
//        testBtn.setBackgroundImage(UIImage(named: "ADImage"), for: .normal)
////        let btn = WQButton()
//        
////        btn.wm.setImageMasks(20)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            debugPrint("++++++++++++")
//            testBtn.setTitle("测试按钮22", for: .normal)
////            testBtn.isEnabled = false
////            testBtn.setImage(UIImage(named: "箭头"), for: .normal)
//        }
        // Do any additional setup after loading the view.
//        self.setupButtons()
        self.setupMultiButtons()
    }
    
    func setupButtons() {
        let btn1 = WQButton("标题在左", image: UIImage(named: "首页6"), alignment: .left, state: .normal)
        btn1.backgroundColor = UIColor.red
        btn1.setTitleColor(UIColor.black, for: .normal)
        btn1.frame = CGRect(x: 50, y: 100, width: 120, height: 100)
        self.view.addSubview(btn1)
        
        let btn2 = WQButton("标题在右", image: UIImage(named: "首页6"), alignment: .right, state: .normal)
        btn2.backgroundColor = UIColor.red
        btn2.setTitleColor(UIColor.black, for: .normal)
        btn2.frame = CGRect(x: 250, y: 100, width: 120, height: 100)
        self.view.addSubview(btn2)
        
        let btn3 = WQButton("标题在上", image: UIImage(named: "首页6"), alignment: .top, state: .normal)
        btn3.backgroundColor = UIColor.red
        btn3.setTitleColor(UIColor.black, for: .normal)
        btn3.frame = CGRect(x: 50, y: 250, width: 120, height: 100)
        self.view.addSubview(btn3)
        
        let btn4 = WQButton("标题在下", image: UIImage(named: "首页6"), alignment: .bottom, state: .normal)
        btn4.backgroundColor = UIColor.red
        btn4.setTitleColor(UIColor.black, for: .normal)
        btn4.frame = CGRect(x: 250, y: 250, width: 120, height: 100)
        self.view.addSubview(btn4)
    }
    func setupMultiButtons() {
        let btn1 = WQButton("指定图片尺寸", image: UIImage(named: "首页6"), alignment: .left, state: .normal)
       
        btn1.backgroundColor = UIColor.green
        btn1.titleLabel?.backgroundColor = UIColor.yellow
         btn1.imgSize = CGSize(width: 20, height: 20)
        btn1.setTitleColor(UIColor.black, for: .normal)
        btn1.frame = CGRect(x: 50, y: 400, width: 130, height: 100)
        debugPrint("+++++++++++++")
        self.view.addSubview(btn1)
        debugPrint("==============")
//        btn1.imgSize = CGSize(width: 20, height: 20)
//        let btn2 = WQButton("标题在右", image: UIImage(named: "首页6"), alignment: .right, state: .normal)
//        btn2.backgroundColor = UIColor.green
//        btn2.setTitleColor(UIColor.black, for: .normal)
//        btn2.frame = CGRect(x: 250, y: 400, width: 120, height: 100)
//        self.view.addSubview(btn2)
        
//        let btn3 = WQButton("标题在上", image: UIImage(named: "首页6"), alignment: .top, state: .normal)
//        btn3.backgroundColor = UIColor.red
//        btn3.setTitleColor(UIColor.black, for: .normal)
//        btn3.frame = CGRect(x: 50, y: 250, width: 120, height: 100)
//        self.view.addSubview(btn3)
//
//        let btn4 = WQButton("标题在下", image: UIImage(named: "首页6"), alignment: .bottom, state: .normal)
//        btn4.backgroundColor = UIColor.red
//        btn4.setTitleColor(UIColor.black, for: .normal)
//        btn4.frame = CGRect(x: 250, y: 250, width: 120, height: 100)
//        self.view.addSubview(btn4)
    }
}
