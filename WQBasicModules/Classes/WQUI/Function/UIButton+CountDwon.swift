//
//  UIButton+CountDwon.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/11/4.
//

import UIKit

// MARK: - -- Count Down
public

extension UIButton {
    struct CountDownKeys {
        static let backgroundColor = "wq.button.backgroundColor"
        static let timerSource = "wq.button.timerSource"
        static let transition = "wq.view.transition.animationKey"
    }
    private
    var source: DispatchSource? {
        set{
            objc_setAssociatedObject(self, CountDownKeys.timerSource, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            return objc_getAssociatedObject(self, CountDownKeys.timerSource) as? DispatchSource
        }
    }
//    private var timer: DispatchTime
//    var countDwonBackgroundColor: UIColor? {
//        set {
//
//        }
//        get {
//
//        }
//    }
    
//    var isCanCancel:Bool {
//    }
    
    public func countDwon(_ count: Int) {
        
        if let source = self.source {
            source.cancel()
        } else {
            source = DispatchSource()
            source
        }
        source?.
    }
}
