//
//  NoteBook.swift
//  UIWebView_NoteBook
//
//  Created by 王强 on 2021/5/29.
//  Copyright © 2021 www.coolketang.com. All rights reserved.
//

import UIKit
import WebKit
open class NoteBook: UIView {
    public let webView = WKWebView(frame: .zero)
    public override init(frame: CGRect) {
        super.init(frame: frame) 
        self.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.rightAnchor.constraint(equalTo: self.rightAnchor),
            webView.leftAnchor.constraint(equalTo: self.leftAnchor),
            webView.topAnchor.constraint(equalTo: self.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func load() {
        guard let url = Bundle(for: self.classForCoder).url(forResource: "NoteBook", withExtension: "html") else {
             return
        }
        webView.loadFileURL(url, allowingReadAccessTo: Bundle.main.bundleURL)
    }
    
    open func insertImage(_ imgPath: String) {
        webView.evaluateJavaScript("insertImage('\(imgPath)')")
    }
    
    open func getNote()  {
        webView.evaluateJavaScript("getNote()", completionHandler: nil)
    }
}
