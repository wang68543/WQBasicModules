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
//    let webView = WQWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(webView)
        self.webView.load(URLRequest(url: URL(string: "https://www.baidu.com/")!))
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        webView.frame = self.view.bounds
//    }
}
