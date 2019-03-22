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
    var progressLayer: WQWebViewProgressLayer {
        set {
            objc_setAssociatedObject(self, &WKWebViewProgressKey, newValue, .OBJC_ASSOCIATION_ASSIGN) //无需强引用 创建的时候就会加到superLayer上面
        }
        get {
            if let progressLayer = objc_getAssociatedObject(self, &WKWebViewProgressKey) as? WQWebViewProgressLayer {
                return progressLayer
            } else {
               let progress = WQWebViewProgressLayer(for: self)
               progress.zPosition = 1000.0
               self.layer.addSublayer(progress)
               self.progressLayer = progress
               return progress
            }
        }
    }
}
