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
        // Do any additional setup after loading the view.
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
