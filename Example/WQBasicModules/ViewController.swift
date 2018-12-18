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
    class WQPresentionView: UIView {
        
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
        let queuen = DispatchQueue(label: "test", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        for idx  in 0 ..< 50 {
//            queuen.async {
                let test = TestModel("12345")
                WQCache.default["test"] = test
            let model:TestModel? = WQCache.default["test"]
                debugPrint("==",model)
//            }
        }
       debugPrint("************")
        
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
        if "122334qq.com".isEmail {
            debugPrint("是邮箱地址")
        }
//        let tf = UITextField()
//        tf.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//        self.view.addSubview(tf)
//        tf.becomeFirstResponder()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
//            debugPrint(UIApplication.shared.windows)
//        }
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
    
   
    @IBAction func webViewAction(_ sender: UIButton) {
//        self.navigationController?.navigationBar.isTranslucent = false
        let presentionView = WQPresentionView()
        
        presentionView.backgroundColor = UIColor.red
//        presentionView.layer.frame = CGRect(x: 100, y: 400, width: 100, height: 100)
//        let keyPath = "backgroundColor"
//        let animation = CABasicAnimation(keyPath: keyPath)
//        animation.fromValue = UIColor.clear.cgColor
//        animation.toValue = UIColor.black.cgColor
//        animation.duration = 0.25
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        self.view.addSubview(presentionView)
//        presentionView.layer.add(animation, forKey: "animate")
        
//        let keyPath1 = "position"
//        let animation1 = CABasicAnimation(keyPath: keyPath1)
//        animation1.fromValue =  CGPoint(x: 0, y: 400)
//        animation1.toValue = CGPoint(x: 330, y: 400)
//        animation1.fillMode = .forwards
//        animation1.duration = 0.5
//        animation1.isRemovedOnCompletion = false
//        presentionView.layer.add(animation1, forKey: "animate1")
//        let keyPath2 = "bounds"
//        let animation2 = CABasicAnimation(keyPath: keyPath2)
//        animation2.fromValue = CGRect(x: 0, y: 400, width: 100, height: 100)
//        animation2.toValue = CGRect(x: UIScreen.main.bounds.width - 200, y: 400, width: 200, height: 200)
//        animation2.fillMode = .forwards
//        animation2.duration = 5
//        animation2.isRemovedOnCompletion = false
//        presentionView.layer.add(animation2, forKey: "animate2")
        
        
//        let presention = WQPresentationController.init(transitionReverse: presentionView, size: CGSize(width: 200, height: 200), initial: .bottom, show: .center)
//        let presention = WQPresentationController.init(position: presentionView, to: CGPoint(x: 200, y: 200), size: CGSize(width: 400, height: 400), bounceType: WQPresentationController.PositionBounce.bounceCenter )
        let presention = WQPresentCenterController(presentionView, size: CGSize(width: 400, height: 400))
        presention.animateDuration = 0.5
//        presention.edgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        presention.containerView.backgroundColor = UIColor.green
        presention.interactionDissmissDirection = .down
        presention.isEnableSlideDismiss = true
        presention.show(animated: true)
        
//        let web = WQWebController()
//        self.navigationController?.pushViewController(web, animated: true)
    }
    
}
