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
    let panGR: UIPanGestureRecognizer = UIPanGestureRecognizer()
    let str: String = "123123123"
   
    class WQPresentionView: UIView {
      
    }
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            let presentionView = WQPresentionView()
            let keyPath = \WQPresentationable.containerView.frame
            let item = WQAnimatedItem(keyPath, initial: CGRect.zero, show: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
            let color = WQAnimatedItem.defaultViewBackground()
//            presentionView.wm.show(items: [item,color,TestPresent()])
            //        presentionView.bounds = CGRect(origin: .zero, size: CGSize(width: 400, height: 400))
            presentionView.backgroundColor = UIColor.red
            //        presentionView.wm.show(reverse: .center, from: .bottom)
            //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            //            debugPrint(self.children)
            //            presentionView.wm.dismiss(true)
            //        }
//            presentionView.wm.presentation?.interactionDissmissDirection = .down
//            presentionView.wm.presentation?.isEnableSlideDismiss = true
            let animator: WQTransitioningAnimator = WQTransitioningAnimator(items: [item,color,TestPresent()])
            let present = WQPresentationable(subView: presentionView, animator: animator)
//            present.showInteractive =  WQPropertyDriven
//            present.showInteractive?.completionWidth = 200
//             present.showInteractive?.isInteracting = true
//            present.show(animated: true, in: self, completion: nil)
        default:
            break;
        }
//        sender.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(panGR)
        panGR.addTarget(self, action: #selector(handlePanGesture(_:)))
        debugPrint(Date.distantFuture.timeIntervalSince1970)
//        let str = "123123123"
        
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
 
     
//        picButton.bounds = CGRect(x: 0, y: 0, width: 100, height: 40);
        
       
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
        button.countDown(total: 60, formater: NumberFormatter(countDownFormat: "还剩", suf: "秒"), color: UIColor.red)  
//        WQCache.default["test"] = "123"
        let atrr = NSMutableAttributedString()
        let queuen = DispatchQueue(label: "test", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        for idx  in 0 ..< 50 {
//            queuen.async {
            let model:TestModel? = WQCache.default["test"]
            let test:TestModel? = WQCache.default.object("test", expire: .seconds(10))
//                let test = TestModel("12345")
//                WQCache.default["test"] = test
            
         
            
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
 
//        self.view.frame = self.view.frame.offsetBy(dx: 300, dy: 0)
//        return
//        let second = SecondViewController()
//        second.view.backgroundColor = UIColor.white
//        self.navigationController?.pushViewController(second, animated: true)
//        return
        let presentionView = WQPresentionView()
        let keyPath = \WQPresentationable.containerView.frame
        let item = WQAnimatedItem(keyPath, initial: CGRect.zero, show: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
        let color = WQAnimatedItem.defaultViewBackground()
//        presentionView.wm.show(items: [item,color,TestPresent()])
//        presentionView.bounds = CGRect(origin: .zero, size: CGSize(width: 400, height: 400))
        presentionView.backgroundColor = UIColor.red
//        presentionView.wm.show(reverse: .center, from: .bottom)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//            debugPrint(self.children)
//            presentionView.wm.dismiss(true)
//        }
        let itemFrame = WQAnimatedItem.defaultViewShowFrame()
//        let navkey = \UIViewController.view.frame
//        let viewItem = WQPresentedAnimatedItem(navkey, initial:self.view.frame  , show:self.view.frame.offsetBy(dx: 300, dy: 0))
        let animator = WQTransitioningAnimator(items: [item, color,itemFrame ])
        let presentation = WQPresentationable(subView: presentionView, animator: animator)
        presentation.interactionDissmissDirection = .down
//        presentation.show(animated: true, in: nil, completion: nil)
//        presentation.isEnableTabBackgroundDismiss = true
        
        presentation.shownInParent(self, flag: true, completion: nil)
//        presentation.shownInWindow(true, completion: nil)
        
//        presentionView.wm.presentation?.interactionDissmissDirection = .down
       
//        presentionView.wm.presentation?.shownInWindow(true, completion: nil)
        
//        let presnetion = WQPresentationable(UIView(), frame: .zero, dismiss: .zero, initial: .zero)
//        let keypath = \WQPresentationable.containerView.frame
//        let item = WQTransitioningAnimatedItem(keypath, initial: CGRect(x: 0, y: 0, width: 100, height: 100), show: UIScreen.main.bounds, dismiss: CGRect.zero)
//
//        presnetion[keyPath: item.keyPath] = item.initial
//        presnetion.view.backgroundColor = UIColor.red
//        self.view.addSubview(presnetion.view)
    }
    
}
class TestPresent: WQAnimatedConfigAble {
    func config(_ presented: UIViewController?, presenting: UIViewController?, present state: WQTransitionState) {
        guard state != .initial else {
            return
        }
        presenting?.view.backgroundColor = state == .show ? UIColor.white : UIColor.green
    }
}
