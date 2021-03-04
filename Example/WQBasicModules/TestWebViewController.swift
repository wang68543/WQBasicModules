//
//  TestWebViewController.swift
//  WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/11.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
import WebKit

class TestWebViewController: UIViewController {
  
    let webView = WQWebView()
//    let webView = UIWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.webView.load(URLRequest(url: URL(string: "http://metro.wifi8.com/upload/privacy.html")!))
//        self.webView.loadRequest(URLRequest(url: URL(string: "http://adfile.wifi8.com/uploads/zip/20210219/index.html")!))
//        self.webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com/")!))
//        self.webView.titleDidChange = { [weak self] webTitle in
//            self?.navigationItem.title = webTitle
//        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = self.view.bounds
    }
}
extension TestWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        debugPrint(#function)
        decisionHandler(.allow)
    }
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 preferences: WKWebpagePreferences,
                 decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        debugPrint(#function)
        decisionHandler(.allow, preferences)
    }
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        debugPrint(#function)
        decisionHandler(.allow)
    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint(#function)
    }
 
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugPrint(#function)
    }
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
    }

    
    /** @abstract Invoked when content starts arriving for the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint(#function)
    }
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint(#function)
    }
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
    }
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, nil)
        debugPrint(#function)
    }
 
    @available(iOS 9.0, *)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        debugPrint(#function)
    }
 
    @available(iOS 14.0, *)
    func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
        decisionHandler(true)
        debugPrint(#function)
    }
    
}
extension TestWebViewController: WKUIDelegate {
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        debugPrint(#function)
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == false {
//        [webView loadRequest:navigationAction.request];
            webView.load(navigationAction.request)

        }
//        webView.load(navigationAction.request)
//        let web = WQWebView(frame: self.view.bounds, configuration: configuration)
////        web.frame = self.view.bounds
//        self.view.addSubview(web)
//        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
//            if url.scheme?.hasPrefix("http") == true || url.scheme?.hasPrefix("mailto") == true {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//              }
//            }
        return nil
    }
    @available(iOS 9.0, *)
    func webViewDidClose(_ webView: WKWebView) {
        debugPrint(#function)
    }
 
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
        debugPrint(#function)
    }
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        debugPrint(#function)
        completionHandler(true)
    }

     
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView,
                 runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        completionHandler(defaultText)
        debugPrint(#function)
    }
//    @available(iOS, introduced: 10.0, deprecated: 13.0)
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        debugPrint(#function)
        return true
    }
//    @available(iOS, introduced: 10.0, deprecated: 13.0)
    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        debugPrint(#function)
        return self
        
    }
//    @available(iOS, introduced: 10.0, deprecated: 13.0)
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        debugPrint(#function)
    }
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
        debugPrint(#function)
        completionHandler(nil)
    }
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo) {
        debugPrint(#function)
    }
 
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
        debugPrint(#function)
    }
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo) {
        debugPrint(#function)
    }
}
