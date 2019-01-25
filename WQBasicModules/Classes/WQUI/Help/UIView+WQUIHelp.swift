//
//  UIView+WQUIHelp.swift
//  Pods
//
//  Created by WangQiang on 2019/1/14.
//

import Foundation

//public extension WQModules where Base: UIView {
//    var subtextFields: [textFieldView] {
//        return self.base.subtextFields
//    }
//}
extension UIView {
    /// 当前View所在的控制器
    var containingController: UIViewController? {
        var nextReponder: UIResponder? = self
        repeat {
            nextReponder = nextReponder?.next
            if nextReponder is UIViewController {
                return nextReponder as? UIViewController
            }
        } while (nextReponder != nil)
        return nil
    }
}

private var adjustMoveViewKey: Void?
private var isEnableKeyboardAdjustKey: Void?
private var keyboardDistanceFromtextFieldViewKey: Void?
private var shouldResignOnTouchOutsideKey: Void?
extension UIViewController {
    var keyboardDistanceFromtextFieldView: CGFloat {
        set {
            objc_setAssociatedObject(self, &keyboardDistanceFromtextFieldViewKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return (objc_getAssociatedObject(self, &keyboardDistanceFromtextFieldViewKey) as? CGFloat) ?? 10
        }
    }
    /// 用于上移的View 若为空就用self.view (c会在此View里面查找输入框以及调整位置)
    var adjustMoveView: UIView? {
        set {
            objc_setAssociatedObject(self, &adjustMoveViewKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let moveView = objc_getAssociatedObject(self, &adjustMoveViewKey) as? UIView {
                return moveView
            } else if self.isViewLoaded {
                return self.view
            } else {
                return nil
            }
        }
    }
    var shouldResignOnTouchOutside: Bool {
        set {
            let oldValue = shouldResignOnTouchOutside
            guard newValue != oldValue else { // 避免重复处理
                return
            }
            objc_setAssociatedObject(self, &shouldResignOnTouchOutsideKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return (objc_getAssociatedObject(self, &shouldResignOnTouchOutsideKey) as? Bool) ?? false
        }
    }
//    @discardableResult
//    func enableKeyboardAdjust(_ enable: Bool) -> WQKeyboardManager? {
//        
//    }
//    // 开启键盘监听 (需手动清除)
//    var isEnableKeyboardAdjust: Bool {
//        set {
//            let oldValue = isEnableKeyboardAdjust
//            guard newValue != oldValue else { // 避免重复注册
//                return
//            }
//            if newValue {
//                self.registerAllNotifications()
//                objc_setAssociatedObject(self, &isEnableKeyboardAdjustKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
//            } else {
//                if objc_getAssociatedObject(self, &isEnableKeyboardAdjustKey) != nil { // 曾经注册过
//                    self.unregisterAllNotification()
//                }
//                objc_setAssociatedObject(self, &isEnableKeyboardAdjustKey, nil, .OBJC_ASSOCIATION_ASSIGN)
//            }
//        }
//        get {
//            return (objc_getAssociatedObject(self, &isEnableKeyboardAdjustKey) as? Bool) ?? false
//        }
//    }
    
    
    //    func value(fortextFieldView key: String) -> String? {
    //
    //    }
    //    func setValue(_ value: String, fortextFieldView key: String) {
    //
    //    }
    //    func setValue(_ value: String, fortextFieldView key: Int) {
    //
    //    }
    //    func isEmpty(fortextFieldView key: String) -> Bool {
    //
    //    }
    //    func isEmpty(fortextFieldView tag: Int) -> Bool {
    //
    //    }
}
//private extension UIViewController {
//    func addTapGesture()  {
//
//    }
//    func removeTapGesture() {
//
//    }
//    func registerAllNotifications() {
//        self.registerKeyboardNotification()
//        self.registertextFieldViewNotification()
//        NotificationCenter.default.addObserver(self, selector: #selector(willChangeStatusBarOrientation(_:)), name:  UIApplication.willChangeStatusBarOrientationNotification, object: nil)
//    }
//    func registerKeyboardNotification()  {
//        let center = NotificationCenter.default
//        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        center.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        center.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
//    }
//
//    func registertextFieldViewNotification() {
//        let center = NotificationCenter.default
//        center.addObserver(self, selector: #selector(textFieldViewDidBeginEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
//        center.addObserver(self, selector: #selector(textFieldViewDidBeginEditing(_:)), name: UITextField.textDidEndEditingNotification, object: nil)
//        center.addObserver(self, selector: #selector(textFieldViewDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
//        center.addObserver(self, selector: #selector(textFieldViewDidBeginEditing(_:)), name: UITextView.textDidEndEditingNotification, object: nil)
//    }
//
//    func unregisterAllNotification()  {
//        let center = NotificationCenter.default
//        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        center.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
//        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        center.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
//
//        center.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: nil)
//        center.removeObserver(self, name: UITextField.textDidEndEditingNotification, object: nil)
//        center.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
//        center.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
//
//        center.removeObserver(self, name: UIApplication.willChangeStatusBarOrientationNotification, object: nil)
//    }
//}
//@objc extension UIViewController {
//    func tapGesture(_ sender: UITapGestureRecognizer) {
//        if sender.state == .ended {
//
//        }
//    }
//    func textFieldViewDidBeginEditing(_ note: Notification) {
//
//    }
//    func textFieldViewDidEndEditing(_ note: Notification) {
//
//    }
//    func keyboardWillShow(_ note: Notification) {
//
//    }
//    func keyboardDidShow(_ note: Notification) {
//
//    }
//    func keyboardWillHide(_ note: Notification) {
//
//    }
//    func keyboardDidHide(_ note: Notification) {
//
//    }
//    func willChangeStatusBarOrientation(_ note: Notification) {
//
//    }
//}
