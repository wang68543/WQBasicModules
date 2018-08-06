//
//  ViewController.swift
//  WQBasicModules
//
//  Created by tangtangmang@163.com on 01/21/2018.
//  Copyright (c) 2018 tangtangmang@163.com. All rights reserved.
//

import UIKit
import Foundation
import WQBasicModules
class ViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let btn = WQButton()
        btn.titleAlignment = .bottom
        btn.setImage(UIImage(named: "首页5"), for: .normal)
        btn.setTitle("首页5", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        btn.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        btn.contentVerticalAlignment = .center
        btn.contentHorizontalAlignment = .left
        btn.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        btn.isAllowWrap = true
        self.view.addSubview(btn)
        btn.titleLabel?.backgroundColor = .red
        btn.backgroundColor = .yellow
//        debugPrint(btn.titleLabel?.font)
        
        debugPrint(Bundle.main.infoDictionary?["CFBundleName"] ?? "没有选项")
        debugPrint("1133445566".isLegalPhone())
        let date = Date()
        let otherDate = "2017-04-21".toDate(format: .kAMMAdd)
        debugPrint(date.distance(otherDate, at: .month))
       debugPrint (otherDate.counts(.weekOfMonth))
        
        debugPrint("=====",date.range(.month))
        
        let imageView = UIImageView()
         let strs = "1234567890".split(separator: Character("5"))
        
//        imageView.addTransitionAnimate(timing: kCAMediaTimingFunctionEaseInEaseOut, subtype: kCATransitionFade, duration: 0.2)
        //App-prefs:root=General&path=Network
//        debugPrint(Date().toString(.))
//        self.view.addTransitionAnimate(timing: <#T##String#>, subtype: <#T##String#>, duration: <#T##CFTimeInterval#>)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}
