//
//  WQStarViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/2/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class WQStarViewController: BaseExampleViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let star = WQStarControl()
        star.value = 5
//        star.unSelectedImage = UIImage(named: "003")
//        star.selectedImage = UIImage(named: "001")
//        star.hideUnHighlited = true
        star.starSize = CGSize(width: 36, height: 33)
//        star.valueType = .valueRandom
        star.backgroundColor = .white
        star.frame = CGRect(x: 30, y: 400, width: 300, height: 80)
        self.view.addSubview(star)
    }

}
