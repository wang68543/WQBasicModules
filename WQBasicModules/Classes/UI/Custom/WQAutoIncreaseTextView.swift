//
//  WQAutoIncreaseHeightTextView.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/10/12.
//

import UIKit

open class WQAutoIncreaseTextView: WQTextView {
    
    
    open var maxLimit = CGFloat.nan
    open var minLimit = CGFloat.nan
    
    /// 是否支持自增长
    open var isIncreaseHeight: Bool = false
    
    open var preferredValue = CGFloat.nan {
        didSet {
            cacheValue = preferredValue
        }
    }
    public private(set) var cacheValue: CGFloat = CGFloat.nan
    
    public override func commonInit() {
        super.commonInit()
        self.isScrollEnabled = false
    }
    
    public override func textViewTextDidChange(_ note: Notification) {
        super.textViewTextDidChange(note)
        let size = self.sizeThatFits(CGSize(width: self.maxContentWidth, height: CGFloat.greatestFiniteMagnitude))
        let height = fixTextHeight(size.height)
        guard height != cacheValue else { return }
        cacheValue = height
        
        scrollEnabled(height)
        
        NotificationCenter.default.post(name: WQAutoIncreaseTextView.heightDidChangeNotification, object: self)
    }
    
    override open var intrinsicContentSize: CGSize {
        if cacheValue.isNaN {
            return .zero
        } else {
            return CGSize(width: self.frame.width, height: cacheValue)
        } 
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if self.preferredValue.isNaN {
            self.preferredValue = self.bounds.height
        }
    }
}

public extension WQAutoIncreaseTextView {
    static let heightDidChangeNotification = Notification.Name("heightDidChangeNotification")
}
private extension WQAutoIncreaseTextView {
    var maxContentWidth: CGFloat {
        return self.frame.width - self.contentInset.left - self.contentInset.right
    }
    
    @inline(__always)
    func fixTextHeight(_ height: CGFloat) -> CGFloat {
        var value = height
        if !self.minLimit.isNaN {
            value = max(self.minLimit, height)
        }
        if !self.maxLimit.isNaN {
            value = min(value, self.maxLimit)
        }
        return value
    }
    @inline(__always)
    func scrollEnabled(_ height: CGFloat) {
        guard !self.maxLimit.isNaN else {
            self.isScrollEnabled = false
            return
        }
        if height < self.maxLimit {
            self.isScrollEnabled = false
        } else {
            if !self.isScrollEnabled {
                self.isScrollEnabled = true
                DispatchQueue.main.async {
                    self.scrollBottom()
                }
            }
        }
    }
    
    func scrollBottom() {
        UIView.performWithoutAnimation {
//            let height = self.frame.height - self.contentInset.top - self.contentInset.bottom
            self.contentOffset = CGPoint(x: self.contentOffset.x, y: self.contentSize.height - self.maxLimit)
        }
    }
}
