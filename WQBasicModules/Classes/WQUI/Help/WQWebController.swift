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
    private var titleObservation: NSKeyValueObservation?
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
        configObservation()
        self.navigationItem.hidesBackButton = true
        configLeftItems(false)
    }
    
    private func configObservation() {
        let title = \WKWebView.title
        titleObservation = webView.observe(title, options: .new, changeHandler: { [weak self] _, change in
            guard let weakSelf = self,
                let newValue = change.newValue else {
                    return
            }
            weakSelf.navigationItem.title = newValue
        })
        let canGoBack = \WKWebView.canGoBack
        canGoBackObservation = webView.observe(canGoBack, options: [.new, .old], changeHandler: { [weak self] _, change in
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
        self.webView.frame = self.view.bounds
        self.webView.progressLayer.attachTop()
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
