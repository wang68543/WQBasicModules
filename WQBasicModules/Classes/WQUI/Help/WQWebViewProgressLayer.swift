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
            guard oldValue == webView else {
                return
            }
            if oldValue != webView {
                self.invalidate()
            }
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
    
    public override init() {
        super.init()
        self.backgroundColor = UIColor.lightText.cgColor
        self.lineCap = .round
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
    public func attach(to webView: WKWebView) {
        self.webView = webView
        webView.layer.addSublayer(self)
        self.backgroundColor = UIColor.lightText.cgColor
        self.lineCap = .round
        self.zPosition = 1000
        self.layoutProgressFrame()
    }
    public func layoutProgressFrame() {
        guard let webView = self.webView else {
            return
        }
        var topY: CGFloat = 0
        if #available(iOS 11.0, *) {
            topY = webView.safeAreaInsets.top
        } else {
            topY = webView.scrollView.contentInset.top
        }
        self.frame = CGRect(x: 0, y: topY, width: webView.frame.width, height: self.progressHeight)
    }
    public override func removeFromSuperlayer() {
        super.removeFromSuperlayer()
        self.invalidate()
        debugPrint(#function)
    }
    
    deinit {
        self.invalidate()
        debugPrint("进度条销毁了")
    }
}
private extension WQWebViewProgressLayer {
    func invalidate() {
        progressObservation?.invalidate()
        isLoadingObservation?.invalidate()
        progressObservation = nil
        isLoadingObservation = nil
    }
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
        self.setupHeight(self.progressHeight)
    }
    func setupHeight(_ height: CGFloat) {
        self.lineWidth = height
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: height))
        self.superlayer?.setNeedsLayout()
    }
}
