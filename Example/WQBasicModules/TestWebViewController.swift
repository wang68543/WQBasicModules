//
//  TestWebViewController.swift
//  WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/11.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class TestWebViewController: UIViewController {
  
    let webView = WQWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        self.webView.load(URLRequest(url: URL(string: "https://www.baidu.com/")!))
        self.webView.titleDidChange = { [weak self] webTitle in
            self?.navigationItem.title = webTitle
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = self.view.bounds
    }
}
