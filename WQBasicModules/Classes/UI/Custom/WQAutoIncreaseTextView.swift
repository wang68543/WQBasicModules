//
//  WQAutoIncreaseHeightTextView.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/10/12.
//

import UIKit

open class WQAutoIncreaseTextView: WQTextView {
    open var maxHeight: CGFloat = CGFloat.nan
    open var minHeight: CGFloat = CGFloat.nan
    
    open var preferredHeight: CGFloat = 0 {
        didSet {
            if cacheHeight.isNaN {
                cacheHeight = preferredHeight
            }
        }
    }
    public private(set) var cacheHeight: CGFloat = CGFloat.nan
    
    public override func textViewTextDidChange(_ note: Notification) {
        super.textViewTextDidChange(note)
        let size = self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        if !self.minHeight.isNaN {
            height = max(self.minHeight, height)
        }
        if !self.maxHeight.isNaN {
            height = min(height, self.maxHeight)
        }
        guard height != cacheHeight else { return }
        
        cacheHeight = height
        if !self.maxHeight.isNaN {
            if height < self.maxHeight {
                self.isScrollEnabled = false
            } else {
                self.isScrollEnabled = true
                self.scrollToBottom()
            }
        }
        self.invalidateIntrinsicContentSize()
        self.textContainer.heightTracksTextView = true
    }
    
    override open var intrinsicContentSize: CGSize {
        if cacheHeight.isNaN {
            return .zero
        } else {
            return CGSize(width: self.frame.width, height: cacheHeight)
        } 
       }
    override public func layoutSubviews() {
        super.layoutSubviews()
        if cacheHeight.isNaN {
            self.cacheHeight = self.bounds.height
        }
    }
           
          
}
