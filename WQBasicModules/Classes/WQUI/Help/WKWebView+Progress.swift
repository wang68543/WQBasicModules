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
            if let progress = objc_getAssociatedObject(self, &WKWebViewProgressKey) as? WQWebViewProgressLayer {
                return progress
            } else {
                let progress = WQWebViewProgressLayer(for: self)
                progress.zPosition = 1000.0
                self.progressLayer = progress
                self.layer.addSublayer(progress)
                return progress
            }
        }
    }
    /// 需要外部主动调用
    func reloadProgressFrame() {
        let progress = self.progressLayer
        var topY: CGFloat = 0
        if #available(iOS 11.0, *) {
            topY = self.safeAreaInsets.top
        } else {
            // 如果下级响应者是VC 或者是VCView的子View
            let viewController = (self.next as? UIViewController) ?? self.next?.next as? UIViewController
            topY = UIApplication.shared.statusBarFrame.height
            if let navBar = viewController?.navigationController?.navigationBar,
                !navBar.isHidden && navBar.isTranslucent {
                topY += navBar.frame.height
            }
        }
        progress.frame = CGRect(x: 0, y: topY, width: self.frame.width, height: progress.progressHeight)
    }
    
}
