//
//  WQKeyboardManager.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/1/15.
//

import Foundation
/// 输入框类型
public typealias TextInputView = UIView & UITextInput
public final class WQKeyboardManager {
    public var keyboardDistanceFromTextInputView: CGFloat = 10
    unowned let moveView: UIView
    
    /// 这里会加在控制器的View上 请确保当前View已经在ViewController的结构中了
    public var shouldResignOnTouchOutside: Bool = false {
        didSet {
            if shouldResignOnTouchOutside {
               self.addTapGesture()
            } else {
                tapGesture = nil
            }
        }
    }
    public var tapGesture: UITapGestureRecognizer? {
        didSet {
            tapGesture?.addTarget(self, action: #selector(tapGesture(_:)))
        }
    }
    /// moveView 开始移动之前的位置 (如果moveView是ScrollView 则记录offset)
    private var initialPosition: CGPoint = .zero
    lazy var textInputViews: [TextInputView] = self.moveView.subTextInputs
    private var _textInputView: TextInputView?
    
    public init(_ moveView: UIView) {
        self.moveView = moveView
        self.registerAllNotifications()
    }
    deinit {
        self.unregisterAllNotification()
    }
    public func reloadTextInputViews() {
        textInputViews = moveView.subTextInputs
    }
    public func layoutSuperViewIfNeed() {
        self.moveView.superview?.layoutIfNeeded()
    }
    public func recoveryPoistion() {
        if let scrollView = self.moveView as? UIScrollView {
            scrollView.setContentOffset(initialPosition, animated: UIView.areAnimationsEnabled)
        } else {
            self.moveView.layer.position = initialPosition
            UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                self.layoutSuperViewIfNeed()
            }, completion: nil)
        }
    }
}
extension WQKeyboardManager {
//    func value(forTextInputView key: String) -> String? {
//
//    }
//    func setValue(_ value: String, forTextInputView key: String) {
//
//    }
//    func setValue(_ value: String, forTextInputView key: Int) {
//
//    }
//    func isEmpty(forTextInputView key: String) -> Bool {
//
//    }
//    func isEmpty(forTextInputView tag: Int) -> Bool {
//
//    }
}
private extension WQKeyboardManager {
    func addTapGesture() {
        if let view = self.moveView.containingController?.view {
            let tapGR = UITapGestureRecognizer()
            view.addGestureRecognizer(tapGR)
            tapGesture = tapGR
        } else {
            debugPrint("请先将view添加到Controller的树形结构中")
        }
    }
    func registerAllNotifications() {
        self.registerKeyboardNotification()
        self.registerTextInputViewNotification()
        let center = NotificationCenter.default
        let notificationName: Notification.Name = UIApplication.willChangeStatusBarOrientationNotification
        center.addObserver(self, selector: #selector(willChangeStatusBarOrientation(_:)), name: notificationName, object: nil)
    }
    func registerKeyboardNotification() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func registerTextInputViewNotification() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(textInputViewDidBeginEditing(_:)),
                           name: UITextField.textDidBeginEditingNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(textInputViewDidEndEditing(_:)),
                           name: UITextField.textDidEndEditingNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(textInputViewDidBeginEditing(_:)),
                           name: UITextView.textDidBeginEditingNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(textInputViewDidEndEditing(_:)),
                           name: UITextView.textDidEndEditingNotification,
                           object: nil)
    }
    
    func unregisterAllNotification() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        
        center.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: nil)
        center.removeObserver(self, name: UITextField.textDidEndEditingNotification, object: nil)
        center.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
        center.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
        
        center.removeObserver(self, name: UIApplication.willChangeStatusBarOrientationNotification, object: nil)
    }
}
@objc extension WQKeyboardManager {
    func tapGesture(_ sender: UITapGestureRecognizer) {
        self.moveView.endEditing(true)
        guard initialPosition != .zero else {
            //没有记录过移动位置之前的位置 所以不需要移动
            return
        }
        if sender.state == .ended {
           self.recoveryPoistion()
        }
    }
    func textInputViewDidBeginEditing(_ note: Notification) {
        debugPrint(#function, note.object!)
        guard let inputView = note.object as? TextInputView,
            let _ = self.textInputViews.firstIndex(where: { $0 === inputView }) else {
            _textInputView = nil
            return
        }
        _textInputView = inputView
    }
    func textInputViewDidEndEditing(_ note: Notification) {
        debugPrint(#function, note.object!)
        _textInputView = nil 
    }
    func keyboardWillShow(_ note: Notification) {
        debugPrint(#function)
    }
    func keyboardDidShow(_ note: Notification) {
        debugPrint(#function)
    }
    func keyboardWillHide(_ note: Notification) {
        debugPrint(#function)
    }
    func keyboardDidHide(_ note: Notification) {
        debugPrint(#function)
    }
    func willChangeStatusBarOrientation(_ note: Notification) {
        
    }
}
extension UIView {
    /// 列出当前View的所有输入框
    var subTextInputs: [TextInputView] {
        var inputViews: [TextInputView] = []
        if let textInput = self as? TextInputView {
            inputViews.append(textInput)
        } else if !self.subviews.isEmpty {
            self.subviews.forEach { view in
                inputViews.append(contentsOf: view.subTextInputs)
            }
        }
        return inputViews
    }
}
extension Array where Element: TextInputView {
    /// 列出当前View的所有输入框 并按照 是否isVertical 参照self的坐标系给输入框排序
    func sortedByPosition(isVertical: Bool = true) -> [TextInputView] {
        return self.sorted(by: { input0, input1 in
            let frame0 = input0.convert(input0.frame, to: nil) //转换为window坐标系
            let frame1 = input1.convert(input1.frame, to: nil)
            if isVertical {
                return frame0.minY < frame1.minY
            } else {
                return frame0.minX < frame1.minX
            }
        })
    }
    /// 列出当前View的所有输入框 并按照 是否isVertical 参照self的坐标系给输入框排序
    func sortedByTag() -> [TextInputView] {
        return self.sorted(by: { $0.tag < $1.tag })
    }
    
    var firstResponder: TextInputView? {
        return self.first(where: { $0.isFirstResponder })
    }
}
