//
//  textFieldViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/1/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class TextFieldViewController: UIViewController {
    var keyboardMangaer: WQKeyboardManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardMangaer = WQKeyboardManager(self.view)
        keyboardMangaer.shouldResignOnTouchOutside = true
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let textFiled = UITextField(frame: CGRect(x: 10, y: self.view.frame.height - 100, width: 300, height: 40))
        textFiled.backgroundColor = UIColor.red
        textFiled.maxTextSize = 10
        self.view.addSubview(textFiled)
    }

}
