//
//  WQTextView.swift
//  WQBasicModules_Example
//
//  Created by WangQiang on 2018/11/13.
//

import UIKit

class WQTextView: UITextView {
    let placeholder: UILabel = UILabel()
    var placeholderInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var text: String! {
        set {
            super.text = newValue
        }
        get {
            return super.text
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let insets = placeholderInsets
        self.placeholder.frame = CGRect(x: insets.left,
                                        y: insets.top,
                                        width: self.frame.width - insets.left - insets.right,
                                        height: self.frame.height - insets.top - insets.bottom)
    }
}
