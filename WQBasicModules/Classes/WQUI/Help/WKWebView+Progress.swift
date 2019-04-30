//
//  WKWebView+Progress.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/3/20.
//

import UIKit
import WebKit

private var WKWebViewProgressKey: Void?

public extension WKWebView {
    /// WebView的加载进度条
    @discardableResult
    func attachProgressView() -> WQWebProgressView {
        let progressView = WQWebProgressView(for: self)
        return progressView
    }
//    var progressView: WQWebProgressView {
//        set {
//            objc_setAssociatedObject(self, &WKWebViewProgressKey, newValue, .OBJC_ASSOCIATION_ASSIGN) //无需强引用 创建的时候就会加到superLayer上面
//        }
//        get {
//            if let progressView = objc_getAssociatedObject(self, &WKWebViewProgressKey) as? WQWebProgressView {
//                return progressView
//            } else {
//               let progressView = WQWebProgressView(for: self)
//               self.progressView = progressView
//               return progressView
//            }
//        }
//    }
}
