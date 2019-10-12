//
//  WQTextView.swift
//  WQBasicModules_Example
//
//  Created by WangQiang on 2018/11/13.
//

import UIKit

open class WQTextView: UITextView {

    open var placeholder: String? {
        didSet {
            self.placeholderLabel.text = placeholder
            self.hasPlaceholder = true
            refreshPlaceholder()
        }
    }
    open var attributedPlaceholder: NSAttributedString? {
        didSet {
            self.placeholderLabel.attributedText = attributedPlaceholder
            self.hasPlaceholder = true
            refreshPlaceholder()
        }
    }
    
    open var placeholderInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7) {
        didSet {
            refreshPlaceholder()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(textViewTextDidChange(_:)),
                         name: UITextView.textDidChangeNotification,
                         object: self)
    }
    
    @objc
    public func textViewTextDidChange(_ note: Notification) {
        guard self.hasPlaceholder else {
            return
        }
        if (placeholderLabel.alpha == 1.0 && self.text.isEmpty) || (placeholderLabel.alpha == 0.0 && !self.text.isEmpty) {
            return
        }
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
            super.text = newValue
            self.refreshPlaceholder()
        }
        get {
            return super.text
        }
    }
    
    private func refreshPlaceholder() {
        guard self.hasPlaceholder else {
            return
        }
        placeholderLabel.alpha = self.text.isEmpty ? 1 : 0
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard self.hasPlaceholder else {
            return
        }
        let insets = placeholderInsets
        placeholderLabel.sizeToFit()
        placeholderLabel.frame = CGRect(x: insets.left,
                                        y: insets.top,
                                        width: self.frame.width - insets.left - insets.right,
                                        height: placeholderLabel.frame.height)
    }
    
    private var hasPlaceholder: Bool = false
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = self.font
        let value: CGFloat = 0.7
        label.textColor = UIColor(white: value, alpha: 1.0)
        label.alpha = 0
        self.addSubview(label)
        return label
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
