//
//  WQWebController.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/10.
//

import UIKit
import WebKit
open class WQWebController: UIViewController {
    /// 支持子类自定义初始化WebView
    public var webView = WKWebView() {
        didSet {
            oldValue.removeFromSuperview()
            self.configObservation()
            self.view.addSubview(self.webView)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    } 
    /// 网页加载失败或者 没网的时候 错误的占位页
    public var errorPlaceholderView: UIView? {
        didSet {
            if errorPlaceholderView != nil {
                self.webView.navigationDelegate = self
            } else {
                 self.webView.navigationDelegate = nil
            }
        }
    }
    /// 网页加载失败或者 没网的时候 错误的Html占位页
    public var errorPlaceholderHtmlFilepath: String? {
        didSet {
            if errorPlaceholderHtmlFilepath != nil {
                self.webView.navigationDelegate = self
            } else {
                self.webView.navigationDelegate = nil
            }
        }
    }
    /// 进度条
    public let progressView: CAShapeLayer = CAShapeLayer()
    public var progressHeight: CGFloat = 3.0
    
    /// item 图标
    public var closeActionItemIcon: UIImage = {
        let frameworkBundle = Bundle(for: WQWebController.self)
        guard let path = frameworkBundle.url(forResource: "WQUIBundle", withExtension: "bundle"),
            let bundle = Bundle(url: path),
            let imgPath = bundle.path(forResource: "close@\(Int(UIScreen.main.scale))x", ofType: "png"),
            let img = UIImage(contentsOfFile: imgPath ) else {
                return UIImage()
        }
        return img.withRenderingMode(.alwaysTemplate)
    }()
    
    public var backActionItemIcon: UIImage = {
        let frameworkBundle = Bundle(for: WQWebController.self)
        guard let path = frameworkBundle.url(forResource: "WQUIBundle", withExtension: "bundle"),
            let bundle = Bundle(url: path),
            let imgPath = bundle.path(forResource: "back@\(Int(UIScreen.main.scale))x", ofType: "png"),
            let img = UIImage(contentsOfFile: imgPath ) else {
                return UIImage()
        }
        return img.withRenderingMode(.alwaysTemplate)
    }()
    /// KVO
    private var progressObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    private var isLoadingObservation: NSKeyValueObservation?
    private var canGoBackObservation: NSKeyValueObservation?
    
    private var originalRequest: URLRequest?
    
    public func loadURLString(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        self.loadRequest(request)
    }
    public func loadRequest(_ request: URLRequest) {
        self.originalRequest = request
        self.webView.load(request)
    }
    /// 刷新
    public func reload() {
        if let request = self.originalRequest {
            self.loadRequest(request)
        }
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        self.progressView.lineWidth = progressHeight
        self.progressView.bounds = CGRect(origin: .zero, size: CGSize(width: 0, height: progressHeight))
        self.progressView.strokeStart = 0.0
        self.progressView.strokeEnd = 0.0
        self.view.layer.addSublayer(self.progressView)
        defaultProgressApperance()
        configObservation()
        self.navigationItem.hidesBackButton = true
        configLeftItems(false)
    }
    /// 进度条默认外观配置
    open func defaultProgressApperance() {
        // 背景色默认是透明色
        progressView.backgroundColor = UIColor.lightText.cgColor
        progressView.strokeColor = UIColor.blue.cgColor
        self.progressView.lineCap = .round
        self.progressView.lineJoin = .round
    }
    
    private func configObservation() {
        let progress = \WKWebView.estimatedProgress
        progressObservation = webView.observe(progress, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.progressView.strokeEnd = CGFloat(newValue)
        })
   
        let title = \WKWebView.title
        titleObservation = webView.observe(title, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.navigationItem.title = newValue
        })
        let isLoading = \WKWebView.isLoading
        isLoadingObservation = webView.observe(isLoading, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.progressView.isHidden = !newValue
            if !newValue {
                weakSelf.progressView.strokeEnd = 0.0
            }
        })
        let canGoBack = \WKWebView.canGoBack
        canGoBackObservation = webView.observe(canGoBack, options: [.new, .old], changeHandler: { [weak self] _, change in
            self?.progressView.strokeEnd = 0.0
            guard let weakSelf = self,
                let newValue = change.newValue,
                newValue != change.oldValue else { return }
            weakSelf.configLeftItems(newValue)
        })
    }
    
    open func configLeftItems(_ canGoBack: Bool) {
        let btnFrame = CGRect(origin: .zero, size: CGSize(width: 44, height: 44))
        let backBtn = UIButton(frame: btnFrame)
        backBtn.setImage(self.backActionItemIcon, for: .normal)
        if #available(iOS 11.0, *) {
            // do nothing
        } else {
            backBtn.contentHorizontalAlignment = .right
        }
        backBtn.adjustsImageWhenDisabled = false
        backBtn.adjustsImageWhenHighlighted = false
        backBtn.addTarget(self, action: #selector(arrowAction), for: .touchUpInside)
       let arrowItem = UIBarButtonItem(customView: backBtn)
        var items: [UIBarButtonItem] = []
        if #available(iOS 11.0, *) {
            // do nothing
        } else {
            let fixedItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            fixedItem.width = -16
            items.append(fixedItem)
        }
        items.append(arrowItem)
        if canGoBack {
            let closeBtn = UIButton(frame: btnFrame)
            closeBtn.setImage(self.closeActionItemIcon, for: .normal)
            closeBtn.contentHorizontalAlignment = .left
            closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
             let goBackItem = UIBarButtonItem(customView: closeBtn)
            items.append(goBackItem)
        }
        self.navigationItem.leftBarButtonItems = items
        
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let viewW = self.view.frame.width
        let viewH = self.view.frame.height
        if let navBar = self.navigationController?.navigationBar,
            navBar.isTranslucent {//透明
            var rect = CGRect(x: 0, y: 0, width: viewW, height: self.progressView.bounds.height)
            if #available(iOS 11.0, *) {
                 rect.origin.y = self.view.safeAreaInsets.top
            } else {
                rect.origin.y = UIApplication.shared.statusBarFrame.height + navBar.frame.height
            }
            self.progressView.frame = rect
            self.webView.frame = self.view.bounds
        } else {
            self.progressView.frame = CGRect(x: 0, y: 0, width: viewW, height: self.progressView.bounds.height)
            self.webView.frame = CGRect(x: 0, y: self.progressView.frame.maxY, width: viewW, height: viewH - self.progressView.frame.maxY)
        }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: progressHeight * 0.5))
        path.addLine(to: CGPoint(x: self.progressView.frame.maxX, y: progressHeight * 0.5))
        self.progressView.path = path.cgPath
    }
}
@objc extension WQWebController {
    open func arrowAction() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.closeAction()
        }
    }
    open func closeAction() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true)
        } else if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
extension WQWebController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.errorPlaceholderView?.removeFromSuperview()
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let errorView = self.errorPlaceholderView {
            self.view.addSubview(errorView)
            errorView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                errorView.topAnchor.constraint(equalTo: self.view.topAnchor),
                errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
        } else if let path = self.errorPlaceholderHtmlFilepath {
            let request = URLRequest(url: URL(fileURLWithPath: path))
            self.webView.load(request)
        }
    }
       
}
