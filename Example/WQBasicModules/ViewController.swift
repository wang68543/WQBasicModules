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
   public class TestModel: Codable {
        let value: String
        init(_ value: String) {
            self.value = value
        }
    }
 private let picButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
//        let picButton = UIButton(type: .system)
//        picButton.titleAlignment = .right
        //        self.picButton.imgSize = CGSize(width: 30, height: 24)
        //        self.picButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        picButton.setTitleColor(.black, for: .normal)
        picButton.setImage(UIImage(named: "post-ic03"), for: .normal)
        picButton.setTitle("图片", for: .normal)
        picButton.backgroundColor = .yellow
        picButton.titleLabel?.backgroundColor = .green
        picButton.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 13)
        picButton.center = CGPoint(x: 100, y: 100)
        self.view.addSubview(picButton)

       
        
//        let btn =  WQButton()
////        btn.center = CGPoint(x: 100, y: 100)
////        btn.titleAlignment = .bottom
//        btn.setImage(UIImage(named: "首页5"), for: .normal)
//        btn.setTitle("首页5", for: .normal)
//        btn.setTitleColor(.black, for: .normal)
//        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
//        btn.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
//        btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
//        btn.contentVerticalAlignment = .center
//        btn.contentHorizontalAlignment = .left
//        btn.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//        btn.isAllowWrap = true
        
//        self.view.addSubview(btn)
//        btn.titleLabel?.backgroundColor = .red
//        btn.backgroundColor = .yellow
//        debugPrint(btn.titleLabel?.font)
        
        debugPrint(Bundle.main.infoDictionary?["CFBundleName"] ?? "没有选项")
        debugPrint("1133445566".isLegalPhone())
        let date = Date()
        let otherDate = "2017-04-21".toDate(format: .kAMMAdd)
        debugPrint(date.distance(otherDate, at: .month))
       debugPrint (otherDate.counts(.weekOfMonth))
        
        debugPrint("=====",date.range(.month))
        
        let button = SecondViewController.DownButton()
        button.setTitle("测试倒计时", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.backgroundColor = UIColor.yellow
//        WQCache.default["test"] = "123"
        let atrr = NSMutableAttributedString()
        let test = TestModel("12345")
        WQCache.default["test"] = test
        
        let value: ViewController.TestModel? = WQCache.default.object ("233")
 
        
//        cache["testFile"] =
//        let pragra = NSParagraphStyle
//        button.countDown(10, execute: { (sender, count, state) in
//            debugPrint("\(count)")
//            button.setTitle("测试倒计时\(count)", for: state)
//            button.setTitleColor(UIColor.blue, for: state)
//            button.backgroundColor = UIColor.white
//        }) { (sender, flag) -> Bool in
//            //是否恢复原状态
//            return true
//        }
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50);
        self.view.addSubview(button)
        let imageView = UIImageView()
        imageView.fadeImage(UIImage(named: "003"))
        self.view.addSubview(imageView)
//         let strs = "1234567890".split(separator: Character("5"))
        let star = WQStarControl()
//        star.isEnabled = false
        
        star.value = 90
        star.normalImage = UIImage(named: "003")
        star.halfHighlightedImage = UIImage(named: "002")
        star.highlightedImage = UIImage(named: "001")
        star.starSize = CGSize(width: 36, height: 33)
        star.backgroundColor = .white
        star.frame = CGRect(x: 30, y: 400, width: 300, height: 80)
        self.view.addSubview(star)
       tests()
//        imageView.addTransitionAnimate(timing: kCAMediaTimingFunctionEaseInEaseOut, subtype: kCATransitionFade, duration: 0.2)
        //App-prefs:root=General&path=Network
//        debugPrint(Date().toString(.))
//        self.view.addTransitionAnimate(timing: <#T##String#>, subtype: <#T##String#>, duration: <#T##CFTimeInterval#>)
    }
    
    func tests()  -> Bool {
//        let data = Data()
//        do {
//            try data.write(to: FileManager.urlCaches)
//            var b = 10
//            b += 20
//            debugPrint("**********",b)
//        } catch let error {
//            debugPrint(error)
//        }
//        var i = 10
//        i += 20
//        debugPrint("======",i)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}
