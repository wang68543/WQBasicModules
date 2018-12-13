//
//  TestWebViewController.swift
//  WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/11.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
import WebKit
class TestWebViewController: WQWebController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView = WKWebView()
    }
    
}
