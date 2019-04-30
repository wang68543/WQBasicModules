//
//  WQWebView.swift
//  Pods-WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2019/4/30.
//

import UIKit
import WebKit
open class WQWebView: WKWebView {
    public var isAttachProgressTop: Bool = true
    public var progressHeight: CGFloat = 5
    
    public lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .default
        self.addSubview(progressView)
        progressView.progressTintColor = UIColor.blue
        self.configObservation()
        return progressView
    }()
    /// KVO
    private var progressObservation: NSKeyValueObservation?
    private var isLoadingObservation: NSKeyValueObservation?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        debugPrint(#function)
        var progressY: CGFloat = 0
        if !isAttachProgressTop {
            progressY = self.frame.height - self.progressHeight
        } else {
            if #available(iOS 11.0, *) {
               progressY = self.safeAreaInsets.top
            } else {
               progressY = self.scrollView.contentInset.top
            }
        }
        self.progressView.frame = CGRect(x: 0, y: progressY, width: self.frame.width, height: self.progressHeight)
    }
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        self.progressView.progressTintColor = tintColor
    }
    deinit {
        
        self.invalidate()
    }
   
}

extension WQWebView {
    func invalidate() {
        if let observer = progressObservation {
            observer.invalidate()
            self.removeObserver(observer, forKeyPath: "estimatedProgress")
            progressObservation = nil
        }
        if let observer = isLoadingObservation {
            observer.invalidate()
            self.removeObserver(observer, forKeyPath: "loading")
            isLoadingObservation = nil
        }
    }
   
    func configObservation() {
        let progress = \WQWebView.estimatedProgress
        progressObservation = self.observe(progress, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.progressView.progress = Float(newValue)
        })

        let isLoading = \WQWebView.isLoading
        isLoadingObservation = self.observe(isLoading, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.progressView.isHidden = !newValue
            if !newValue {
                 weakSelf.progressView.progress = 0.0
            }
        })
    }
}
