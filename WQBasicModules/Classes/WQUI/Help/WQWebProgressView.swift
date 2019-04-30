//
//  WQWebProgressView.swift
//  AFNetworking
//
//  Created by iMacHuaSheng on 2019/4/30.
//

import UIKit
import WebKit
public class WQWebProgressView: UIProgressView {
    /// KVO
    private var progressObservation: NSKeyValueObservation?
    private var isLoadingObservation: NSKeyValueObservation?
    
    public var webView: WKWebView?
    
    public init(for webView: WKWebView) {
        self.webView = webView
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 5)))
        webView.addSubview(self)
        self.progressViewStyle = .bar
        self.backgroundColor = UIColor.red
        self.addLayout(webView)
//        configObservation(webView)
    }
    private func addLayout(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: view.topAnchor),
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                self.heightAnchor.constraint(equalToConstant: 5)])
        } else {
            let left = NSLayoutConstraint(item: self,
                                          attribute: .left,
                                          relatedBy: .equal,
                                          toItem: view,
                                          attribute: .left,
                                          multiplier: 1.0,
                                          constant: 0)
            let right = NSLayoutConstraint(item: self,
                                           attribute: .right,
                                           relatedBy: .equal,
                                           toItem: view,
                                           attribute: .right,
                                           multiplier: 1.0,
                                           constant: 0)
            let top = NSLayoutConstraint(item: self,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: view,
                                         attribute: .top,
                                         multiplier: 1.0,
                                         constant: 0)
            let height = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1.0,
                                            constant: 5)
            NSLayoutConstraint.activate([left, right, top, height])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            self.invalidate()
        } else {
            if let webView = self.webView {
                configObservation(webView)
            }
            
        }
    }
    deinit {
        debugPrint("是否销毁了")
        invalidate()
    }
}

extension WQWebProgressView {
    func invalidate() {
        if let observer = progressObservation {
            self.webView?.removeObserver(observer, forKeyPath: "estimatedProgress")
            observer.invalidate()
            progressObservation = nil
        }
        if let observer = isLoadingObservation {
            self.webView?.removeObserver(observer, forKeyPath: "isLoading")
            observer.invalidate()
            isLoadingObservation = nil
        }
    }
    func configObservation(_ webView: WKWebView) {
        let progress = \WKWebView.estimatedProgress
        progressObservation = webView.observe(progress, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.progress = Float(newValue)
        })
        
        let isLoading = \WKWebView.isLoading
        isLoadingObservation = webView.observe(isLoading, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.isHidden = !newValue
            if !newValue {
                 weakSelf.progress = 0.0
            }
        })
    }
}
