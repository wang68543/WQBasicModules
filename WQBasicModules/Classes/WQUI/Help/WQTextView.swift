//
//  WQTextView.swift
//  WQBasicModules_Example
//
//  Created by WangQiang on 2018/11/13.
//

import UIKit

public class WQTextView: UITextView {
    public let placeholderLabel: UILabel = UILabel()
    public var placeholderInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        placeholderLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = self.font
        placeholderLabel.backgroundColor = .clear
        //swiftlint:disable object_literal
        placeholderLabel.textColor = UIColor(white: 0.7, alpha: 1.0)
        placeholderLabel.alpha = 0
        self.addSubview(placeholderLabel)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(textViewTextDidChange(_:)),
                         name: UITextView.textDidChangeNotification,
                         object: self)
    }
    
    @objc
    func textViewTextDidChange(_ note: Notification) {
        self.refreshPlaceholder()
    }
    
    override public var delegate: UITextViewDelegate? {
        set {
            super.delegate = newValue
        }
        get {
            self.refreshPlaceholder()
            return super.delegate
        }
    }
    override public var text: String! {
        set {
            super.text = text
            self.refreshPlaceholder()
        }
        get {
            return super.text
        }
    }
    
    private func refreshPlaceholder() {
        placeholderLabel.alpha = self.text.isEmpty ? 1 : 0
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        let insets = placeholderInsets
        placeholderLabel.sizeToFit()
        placeholderLabel.frame = CGRect(x: insets.left,
                                        y: insets.top,
                                        width: self.frame.width - insets.left - insets.right,
                                        height: placeholderLabel.frame.height)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
