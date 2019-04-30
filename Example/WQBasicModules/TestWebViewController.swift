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
class TestWebViewController: UIViewController {
    let webView = WQWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.frame = self.view.bounds
//        self.webView = WKWebView()
//        self.webView.attachProgressView()
        self.webView.load(URLRequest(url: URL(string: "https://www.baidu.com/")!))
    }
    
}
