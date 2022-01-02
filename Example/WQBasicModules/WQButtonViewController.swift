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
        self.setupButtons()
        self.setupMultiButtons()
//        let image = LaunchImage.snapshotLaunch
//        let imageView = UIImageView(image: image)
//        self.view.addSubview(imageView)
//        imageView.frame = UIScreen.main.bounds
    }

    func setupButtons() {
        let btn1 = WQButton("标题在左", image: UIImage(named: "首页6"), alignment: .left, state: .normal)
        btn1.backgroundColor = UIColor.red
        btn1.setTitleColor(UIColor.black, for: .normal)
        btn1.frame = CGRect(x: 50, y: 90, width: 120, height: 100)
        self.view.addSubview(btn1)

        let btn2 = WQButton("标题在右", image: UIImage(named: "首页6"), alignment: .right, state: .normal)
        btn2.backgroundColor = UIColor.red
        btn2.setTitleColor(UIColor.black, for: .normal)
        btn2.frame = CGRect(x: 250, y: 90, width: 120, height: 100)
        self.view.addSubview(btn2)

        let btn3 = WQButton("标题在上", image: UIImage(named: "首页6"), alignment: .top, state: .normal)
        btn3.backgroundColor = UIColor.red
        btn3.setTitleColor(UIColor.black, for: .normal)
        btn3.frame = CGRect(x: 50, y: 200, width: 120, height: 100)
        self.view.addSubview(btn3)

        let btn4 = WQButton("标题在下", image: UIImage(named: "首页6"), alignment: .bottom, state: .normal)
        btn4.backgroundColor = UIColor.red
        btn4.setTitleColor(UIColor.black, for: .normal)
        btn4.frame = CGRect(x: 250, y: 200, width: 120, height: 100)
        self.view.addSubview(btn4)
    }
    func setupMultiButtons() {
        let btn1 = WQButton("指定图片尺寸", image: UIImage(named: "首页6"), alignment: .left, state: .normal)
        btn1.backgroundColor = UIColor.green
        btn1.imgSize = CGSize(width: 20, height: 20)
        btn1.setTitleColor(UIColor.black, for: .normal)
        btn1.frame = CGRect(x: 50, y: 310, width: 150, height: 100)
        self.view.addSubview(btn1)

        let btn2 = WQButton("标题支持多行显示", image: UIImage(named: "首页6"), alignment: .right, state: .normal)
        btn2.backgroundColor = UIColor.green
        btn2.isAllowWrap = true
        btn2.setTitleColor(UIColor.black, for: .normal)
        btn2.frame = CGRect(x: 250, y: 310, width: 100, height: 100)
        self.view.addSubview(btn2)

        let btn3 = WQButton("支持Button原有属性设置", image: UIImage(named: "首页6"), alignment: .right, state: .normal)
        btn3.backgroundColor = UIColor.red
        btn3.setTitleColor(UIColor.black, for: .normal)
        btn3.frame = CGRect(x: 50, y: 420, width: 300, height: 120)
        btn3.contentVerticalAlignment = .bottom
        btn3.contentHorizontalAlignment = .right
        btn3.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        btn3.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn3.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 5)
        self.view.addSubview(btn3)
    }
}
// public extension Calendar {
//    func numberOfDaysInMonth(for date: Date) -> Int {
//        return range(of: .day, in: .month, for: date)!.count
//    }
//    func numberOfDaysInYear(for date: Date) -> Int {
//        return range(of: .day, in: .year, for: date)!.count
//    }
// }
