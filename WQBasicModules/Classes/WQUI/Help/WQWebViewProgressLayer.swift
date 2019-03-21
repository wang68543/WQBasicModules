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
            let color = self.webView?.tintColor ?? UIColor.blue
            self.strokeColor = color.cgColor
            self.strokeEnd = 0.0
            self.configObservation()
        }
    }
    
    public var progressHeight: CGFloat = 10.0 {
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
        self.configObservation()
        
    }
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
    
}
extension WQWebViewProgressLayer {
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
//            weakSelf.isHidden = !newValue
            if !newValue {
                weakSelf.strokeEnd = 0.0
            }
        })
    }
    
    func setupHeight(_ height: CGFloat) {
        self.lineWidth = height
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: height))
        self.superlayer?.setNeedsLayout()
    }
}
