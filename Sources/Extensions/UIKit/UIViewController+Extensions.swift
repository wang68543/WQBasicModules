//
//  UIViewController+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/7/26.
//

import Foundation
public extension UIViewController {
    /// SwifterSwift: Check if ViewController is onscreen and not hidden.
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return isViewLoaded && view.window != nil
    }
}
