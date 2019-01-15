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
    /// 进度条
    public let progressView: CAShapeLayer = CAShapeLayer()
    public var progressHeight: CGFloat = 3.0
    
    /// KVO
    private var progressObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    private var isLoadingObservation: NSKeyValueObservation?
    private var canGoBackObservation: NSKeyValueObservation?
    
    public func loadURLString(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        self.loadRequest(request)
    }
    public func loadRequest(_ request: URLRequest) {
        self.webView.load(request)
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
        canGoBackObservation = webView.observe(canGoBack, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.configLeftItems(newValue)
        })
    }
    
    public func configLeftItems(_ canGoBack: Bool) {
        let frameworkBundle = Bundle(for: WQWebController.self)
        guard let path = frameworkBundle.url(forResource: "WQUIBundle", withExtension: "bundle"),
            let bundle = Bundle(url: path ) else {
            return
        }
       
        let scale = Int(UIScreen.main.scale)
        let btnFrame = CGRect(origin: .zero, size: CGSize(width: 44, height: 44))
       
        var arrowItem: UIBarButtonItem
        if self.navigationItem.leftBarButtonItem != nil {
            arrowItem = self.navigationItem.leftBarButtonItem!
        } else {
            let backBtn = UIButton(frame: btnFrame)
            let backImgPath = bundle.path(forResource: "back@\(scale)x", ofType: "png")
            let backImg = UIImage(contentsOfFile: backImgPath ?? "")?.withRenderingMode(.alwaysTemplate)
            backBtn.setImage(backImg, for: .normal)
            if #available(iOS 11.0, *) {
                // do nothing
            } else {
                backBtn.contentHorizontalAlignment = .right
            }
            backBtn.adjustsImageWhenDisabled = false
            backBtn.adjustsImageWhenHighlighted = false
            backBtn.addTarget(self, action: #selector(arrowAction), for: .touchUpInside)
            arrowItem = UIBarButtonItem(customView: backBtn)
            
        }
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
            let closeImgPath = bundle.path(forResource: "close@\(scale)x", ofType: "png")
            let closeImg = UIImage(contentsOfFile: closeImgPath ?? "")?.withRenderingMode(.alwaysTemplate)
            let closeBtn = UIButton(frame: btnFrame)
            closeBtn.setImage(closeImg, for: .normal)
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
     func arrowAction() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.closeAction()
        }
    }
    func closeAction() {
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
