//
//  TestButton.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/3/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class TestButton: UIButton {
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        debugPrint(#function)
    }
    open override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        debugPrint(#function)
    }
    open override func backgroundRect(forBounds bounds: CGRect) -> CGRect {
        debugPrint("--------",#function)
        let rect = super.backgroundRect(forBounds: bounds)
        debugPrint("value:\(bounds),cal:\(rect)")
        return rect
    }
    
    open override func contentRect(forBounds bounds: CGRect) -> CGRect {
        debugPrint("*************",#function)
        let rect = super.contentRect(forBounds: bounds)
        debugPrint("value:\(bounds),cal:\(rect)")
        return rect
    }
    
    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        debugPrint("=======",#function)
        let rect = super.titleRect(forContentRect: bounds)
        debugPrint("value:\(bounds),cal:\(rect)")
        return rect
    }
    
    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        debugPrint("=======",#function)
        let rect = super.imageRect(forContentRect: contentRect)
        debugPrint("value:\(contentRect),cal:\(rect)")
        return rect
    }
    

}
