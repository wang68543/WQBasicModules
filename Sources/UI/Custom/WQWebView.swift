//
//  WQWebView.swift
//  Pods-WQBasicModules_Example
//
//  Created by WQ on 2019/4/30.
//

import UIKit
import WebKit
//https://juejin.im/post/6887161842406260744
open class WQWebView: WKWebView {
    public var isAttachProgressTop: Bool = true
    public var progressHeight: CGFloat = 2 {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
//    //包装请求头内容
//    - (WKNavigation *)loadRequest:(NSURLRequest *)request{
//        NSLog(@"发起请求:%@ method:%@",request.URL.absoluteString,request.HTTPMethod);
//        NSMutableURLRequest *mutableRequest = [request mutableCopy];
//        NSMutableDictionary *requestHeaders = [request.allHTTPHeaderFields mutableCopy];
//        //判断是否是POST请求，POST请求需要包装request中的body内容到请求头中（会有丢失body问题的产生）
//        //,包装完成之后重定向到拦截的协议中自己包装处理请求数据内容，拦截协议是GCURLProtocol，请自行搜索
//        if ([mutableRequest.HTTPMethod isEqualToString:@"POST"] && ([mutableRequest.URL.scheme isEqualToString:@"http"] || [mutableRequest.URL.scheme isEqualToString:@"https"])) {
//            NSString *absoluteStr = mutableRequest.URL.absoluteString;
//            if ([[absoluteStr substringWithRange:NSMakeRange(absoluteStr.length-1, 1)] isEqualToString:@"/"]) {
//                absoluteStr = [absoluteStr stringByReplacingCharactersInRange:NSMakeRange(absoluteStr.length-1, 1) withString:@""];
//            }
//
//            if ([mutableRequest.URL.scheme isEqualToString:@"https"]) {
//                absoluteStr = [absoluteStr stringByReplacingOccurrencesOfString:@"https" withString:WkCustomHttps];
//            }else{
//                absoluteStr = [absoluteStr stringByReplacingOccurrencesOfString:@"http" withString:WkCustomHttp];
//            }
//
//            mutableRequest.URL = [NSURL URLWithString:absoluteStr];
//            NSString *bodyDataStr = [[NSString alloc]initWithData:mutableRequest.HTTPBody encoding:NSUTF8StringEncoding];
//            [requestHeaders addEntriesFromDictionary:@{@"httpbody":bodyDataStr}];
//            mutableRequest.allHTTPHeaderFields = requestHeaders;
//
//            NSLog(@"当前请求为POST请求Header:%@",mutableRequest.allHTTPHeaderFields);
//
//        }
//        return [super loadRequest:mutableRequest];
//    }

    public var titleDidChange: ((String?) -> Void)? {
        didSet {
            if titleDidChange == nil {
                self.invalidateTitleObservation()
            } else {
                self.configTitleObservation()
            }
        }
    }

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
    private var titleObservation: NSKeyValueObservation?

    open override func layoutSubviews() {
        super.layoutSubviews()
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
        debugPrint("浏览器销毁了")
        self.invalidate()
        self.invalidateTitleObservation()
    }

}

extension WQWebView {
    func invalidate() {
        if #available(iOS 11.0, *) {
            progressObservation = nil
            isLoadingObservation = nil
        } else {
            if let observer = progressObservation {
                self.removeObserver(observer, forKeyPath: "estimatedProgress")
                progressObservation = nil
            }
            if let observer = isLoadingObservation {
                self.removeObserver(observer, forKeyPath: "loading")
                isLoadingObservation = nil
            }
        }
    }

    func configTitleObservation() {
        guard self.titleObservation == nil else {
            return
        }
        let keyPath = \WQWebView.title
        titleObservation = self.observe(keyPath, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.titleDidChange?(newValue)
        })
    }

    func invalidateTitleObservation() {
        if #available(iOS 11.0, *) {
            titleObservation = nil
        } else {
            if let observer = titleObservation {
                self.removeObserver(observer, forKeyPath: "title")
                titleObservation = nil
            }
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
