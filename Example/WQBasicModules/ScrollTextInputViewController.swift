//
//  ScrollTextInputViewController.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/1/24.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class ScrollTextInputViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var keyboardMangaer: WQKeyboardManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardMangaer = WQKeyboardManager(self.scrollView)
        keyboardMangaer.shouldResignOnTouchOutside = true
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let textFiled = UITextField(frame: CGRect(x: 10, y: self.view.frame.height - 20, width: 300, height: 40))
        textFiled.backgroundColor = UIColor.red
        self.scrollView.addSubview(textFiled)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
