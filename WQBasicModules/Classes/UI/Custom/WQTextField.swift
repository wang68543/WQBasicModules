//
//  WQTextField.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/10/16.
//

import UIKit

open class WQTextField: UITextField {
    open var leftWidth: CGFloat = CGFloat.nan
    open var leftFrame: CGRect = CGRect.zero
    
    open var rightWidth: CGFloat = CGFloat.nan
    open var rightFrame: CGRect = CGRect.zero
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        if leftFrame != .zero {
            return leftFrame
        } else if !leftWidth.isNaN {
            return CGRect(x: bounds.minX, y: bounds.minY, width: leftWidth, height: bounds.height)
        } else {
            return super.leftViewRect(forBounds: bounds)
        }
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        if rightFrame != .zero {
            return rightFrame
        } else if !rightWidth.isNaN {
            return CGRect(x: bounds.maxX - rightWidth, y: bounds.minY, width: rightWidth, height: bounds.height)
        } else {
            return super.rightViewRect(forBounds: bounds)
        }
    }
}

public extension WQTextField {
    func left(padding: CGFloat) {
        let view = UIView()
        left(view, width: padding)
    }
    
    func left(_ icon: UIImage?, width: CGFloat) {
        let imageView = UIImageView(image: icon)
        imageView.contentMode = .center
        self.left(imageView, width: width)
    }
    
    func left(_ view: UIView, width: CGFloat) {
        leftView = view
        leftWidth = width
        leftViewMode = .always
    }
}
