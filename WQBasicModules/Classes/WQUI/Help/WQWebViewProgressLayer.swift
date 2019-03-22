//
//  WQWebViewProgressLayer.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/3/21.
//

import UIKit
import WebKit
public class WQWebViewProgressLayer: CAShapeLayer {
    public weak private(set) var webView: WKWebView? {
        didSet {
           self.initialApperance()
           self.configObservation()
        }
    }
    
    public var progressHeight: CGFloat = 3.0 {
        didSet {
           self.setupHeight(progressHeight)
        }
    }
    /// KVO
    private var progressObservation: NSKeyValueObservation?
    private var isLoadingObservation: NSKeyValueObservation?
    
    public init(for webView: WKWebView) {
        self.webView = webView
        super.init()
        self.setupHeight(self.progressHeight) 
        self.backgroundColor = UIColor.lightText.cgColor
        self.lineCap = .round
        self.initialApperance()
        self.configObservation()
        
    }
    // strokeEnd 会执行动画 动画的时候 会调用这个方法来创建展示layer 仅仅只用于动画展示
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    public override func layoutSublayers() {
        super.layoutSublayers()
        self.lineWidth = self.frame.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.frame.height * 0.5))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height * 0.5))
        self.path = path.cgPath
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 这里需要在Webview的尺寸确定之后再刷新
    func attachTop() {
        guard let webView = self.webView else {
            return
        }
        var topY: CGFloat = 0
        if #available(iOS 11.0, *) {
            topY = webView.safeAreaInsets.top
        } else {
            // 如果下级响应者是VC 或者是VCView的子View
            let viewController = (webView.next as? UIViewController) ?? webView.next?.next as? UIViewController
            topY = UIApplication.shared.statusBarFrame.height
            if let navBar = viewController?.navigationController?.navigationBar,
                !navBar.isHidden && navBar.isTranslucent {
                topY += navBar.frame.height
            }
        }
        self.frame = CGRect(x: 0, y: topY, width: webView.frame.width, height: self.progressHeight)
    }
}
private extension WQWebViewProgressLayer {
     func configObservation() {
        let progress = \WKWebView.estimatedProgress
        progressObservation = webView?.observe(progress, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.strokeEnd = CGFloat(newValue)
        })
        
        let isLoading = \WKWebView.isLoading
        isLoadingObservation = webView?.observe(isLoading, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.isHidden = !newValue
            if !newValue {
                weakSelf.strokeEnd = 0.0
            }
            
        })
    }
    func initialApperance() {
        let color = self.webView?.tintColor ?? UIColor.blue
        self.strokeColor = color.cgColor
        self.strokeEnd = 0.0
        self.isHidden = false
    }
    func setupHeight(_ height: CGFloat) {
        self.lineWidth = height
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: height))
        self.superlayer?.setNeedsLayout()
    }
}
