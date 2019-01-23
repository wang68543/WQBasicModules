//
//  WQKeyboardManager.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/1/15.
//

import Foundation
/// 输入框类型
public typealias TextFieldView = UIView & UITextInput
public final class WQKeyboardManager {
    public var keyboardDistanceFromtextFieldView: CGFloat = 10
    public var isEnabled: Bool = true
    unowned let moveView: UIView
    public var animationDuration: TimeInterval = 0.25
    public var animationCurve: UIView.AnimationOptions = [.curveEaseInOut]
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
//    public var touchResignedGestureIgnoreClasses: Set<> = Set()
    /// moveView 开始移动之前的位置 (如果moveView是ScrollView 则记录offset)
    private var initialPosition: CGPoint = .zero
    lazy var textFieldViews: [TextFieldView] = self.textResponders()
    private var _textFieldView: TextFieldView?
    private var _keyboardShowing: Bool = false
    private var _kbShowNotification: Notification?
    private var _kbSize: CGSize = .zero
//    private var moveViewBeginOrigin: CGPoint
    public init(_ moveView: UIView) {
        self.moveView = moveView
//        moveViewBeginOrigin = moveView.frame.origin
        self.registerAllNotifications()
    }
    deinit {
        self.unregisterAllNotification()
    }
    public func reloadtextFieldViews() {
        textFieldViews = self.textResponders()
    }
    public func layoutSuperViewIfNeed() {
        self.moveView.superview?.layoutIfNeeded()
    }
    public func recoveryPoistion() {
        self.moveView.layer.position = initialPosition
        UIView.animate(withDuration: animationDuration, delay: 0, options: [animationCurve, .beginFromCurrentState], animations: {
            self.layoutSuperViewIfNeed()
        }, completion: nil)
    }
}
extension WQKeyboardManager {
//    func value(forTextFieldView key: String) -> String? {
//
//    }
//    func setValue(_ value: String, forTextFieldView key: String) {
//
//    }
//    func setValue(_ value: String, forTextFieldView key: Int) {
//
//    }
//    func isEmpty(forTextFieldView key: String) -> Bool {
//
//    }
//    func isEmpty(forTextFieldView tag: Int) -> Bool {
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
    func textResponders() -> [TextFieldView] {
        var inputViews: [TextFieldView] = []
        inputViews = self.moveView.subtextFieldViews
            .filter({ canBecomeFirstResponder(for: $0) })
        return inputViews
    }
    /// 确认是否可以响应
    func canBecomeFirstResponder(for view: TextFieldView) -> Bool {
        var canBecome: Bool = view.canBecomeFirstResponder
        if let textView = view as? UITextView {
            canBecome = textView.isEditable
        } else if let textField = view as? UITextField {
            canBecome = textField.isEnabled
        }
        return canBecome && !view.isHidden && view.alpha > 0.01 && view.isUserInteractionEnabled
    }
    func registerAllNotifications() {
        self.registerKeyboardNotification()
        self.registertextFieldViewNotification()
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
    
    func registertextFieldViewNotification() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(textFieldViewDidBeginEditing(_:)),
                           name: UITextField.textDidBeginEditingNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(textFieldViewDidEndEditing(_:)),
                           name: UITextField.textDidEndEditingNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(textFieldViewDidBeginEditing(_:)),
                           name: UITextView.textDidBeginEditingNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(textFieldViewDidEndEditing(_:)),
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
    func textFieldViewDidBeginEditing(_ note: Notification) {
        debugPrint(#function, note.object!)
        guard let inputView = note.object as? TextFieldView,
        self.isEnabled else {
            _textFieldView = nil
            return
        }
        _textFieldView = inputView
        if _keyboardShowing {
            optimizedAdjustPosition()
        }
    }
    func textFieldViewDidEndEditing(_ note: Notification) {
        debugPrint(#function, note.object!)
        _textFieldView = nil
    }
    func keyboardWillShow(_ note: Notification) {
        debugPrint(#function)
        initialPosition = self.moveView.layer.position
        guard let userInfo = note.userInfo,
         let cuvreValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
         let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
        let kbFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            debugPrint("缺少参数")
            return
        }
        let cuvre = UIView.AnimationOptions(rawValue: cuvreValue)
        _kbShowNotification = note
        _keyboardShowing = true
        animationCurve.insert(cuvre)
        if duration != 0.0 {
            animationDuration = duration
        }
        let oldKBSize = _kbSize
        let screenSize = UIScreen.main.bounds
        let intersectRect = screenSize.intersection(kbFrame)
        if intersectRect.isNull {
            _kbSize = CGSize(width: screenSize.width, height: 0)
        } else {
            _kbSize = intersectRect.size
        }
        
        guard self.isEnabled else {
            debugPrint("已禁用")
            return
        }
        if oldKBSize != _kbSize,
            _textFieldView != nil {
            self.optimizedAdjustPosition()
        }
    }
    func keyboardDidShow(_ note: Notification) {
        debugPrint(#function)
        guard self.isEnabled else {
            return
        }
        //If _textFieldView viewController is presented as formSheet,
        //then adjustPosition again because iOS internally update formSheet frame on keyboardShown.
        if _keyboardShowing == true,
            _textFieldView != nil,
            let controller = self.moveView.containingController,
            (controller.modalPresentationStyle == .formSheet || controller.modalPresentationStyle == .pageSheet) {
            self.optimizedAdjustPosition()
        }
    }
    func keyboardWillHide(_ note: Notification) {
        debugPrint(#function)
        _kbShowNotification = nil
        _keyboardShowing = false
        guard let userInfo = note.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                debugPrint("缺少参数")
                return
        }
        if duration != 0.0 {
            animationDuration = duration
        }
        guard self.isEnabled else {
            return
        }
        self.recoveryPoistion()
    }
    func keyboardDidHide(_ note: Notification) {
        debugPrint(#function)
        _kbSize = .zero
    }
    func willChangeStatusBarOrientation(_ note: Notification) {
        
    }
}
extension WQKeyboardManager {
    var keyWindow: UIWindow? {
        return self.moveView.window ?? UIApplication.shared.keyWindow
    }
    //swiftlint:disable function_body_length
    func optimizedAdjustPosition() {
        guard let inputView = _textFieldView,
            let superView = inputView.superview,
        self.textFieldViews.firstIndex(where: { $0 === inputView }) != nil,
        let keyWindow = self.keyWindow else {
            _textFieldView = nil
            return
        }
        let inputViewFrame = inputView.frame
        ///去掉 多余的边
        var moveViewClipFrame = self.moveView.frame
        if #available(iOS 11.0, *),
            moveViewClipFrame != .zero {
            moveViewClipFrame.size.height -= self.moveView.safeAreaInsets.bottom - self.moveView.safeAreaInsets.top
            moveViewClipFrame.origin.y -= self.moveView.safeAreaInsets.top
        }
        let moveViewFrameInWindow = self.moveView.superview?.convert(moveViewClipFrame, to: keyWindow) ?? CGRect.zero
        let textFrameInWindow = superView.convert(inputView.frame, to: keyWindow)
        var kbSize = _kbSize
        kbSize.height += self.keyboardDistanceFromtextFieldView
        let kbFrame = CGRect(x: 0, y: UIScreen.main.bounds.height - kbSize.height, width: kbSize.width, height: kbSize.height)
        
        let intersectRect = textFrameInWindow.intersection(kbFrame)
        if intersectRect.isNull { // 没有遮住输入框 需要下移
            var targetF = textFrameInWindow
            targetF.origin.y = kbFrame.minY - inputViewFrame.height
            let targetTextViewInMoveView = self.moveView.convert(targetF, from: keyWindow)
            if let scrollView = self.moveView as? UIScrollView {
                let targetOffsetY = inputViewFrame.minY - targetTextViewInMoveView.minY
                var offset = scrollView.contentOffset
                offset.y += targetOffsetY
                offset.y = max(targetOffsetY, 0)
                if offset != scrollView.contentOffset {
                    UIView.animate(withDuration: animationDuration,
                                   delay: 0,
                                   options: [animationCurve, .beginFromCurrentState],
                                   animations: {
                                        scrollView.contentOffset = offset
                                    },
                                   completion: nil)
                }
            } else {
                let targetMove = inputViewFrame.minY - targetTextViewInMoveView.minY
                var position = self.moveView.layer.position
                position.y += targetMove
                position.y = max(self.initialPosition.y, position.y)
                if self.moveView.layer.position != position {
                    UIView.animate(withDuration: animationDuration,
                                   delay: 0,
                                   options: [animationCurve, .beginFromCurrentState],
                                   animations: {
                                            self.moveView.layer.position = position
                                    },
                                   completion: nil)
                }
            }
        } else { // 有交集往上移
            let move = intersectRect.height
            if moveViewFrameInWindow.maxY <= kbFrame.minY,
                let scrollView = self.moveView as? UIScrollView { // 有交集 并且scrollView在键盘上面
                let offset = scrollView.contentOffset
                UIView.animate(withDuration: animationDuration,
                               delay: 0,
                               options: [animationCurve, .beginFromCurrentState],
                               animations: {
                                    scrollView.contentOffset = CGPoint(x: offset.x, y: offset.y + move)
                                },
                               completion: nil)
            } else { // 有交集 并且View 在键盘下面
                let position = self.moveView.layer.position
                UIView.animate(withDuration: animationDuration,
                               delay: 0,
                               options: [animationCurve, .beginFromCurrentState],
                               animations: {
                                    self.moveView.layer.position = CGPoint(x: position.x, y: position.y + move)
                                },
                               completion: nil)
            }
        }
    }
}
extension UIView {
    /// 列出当前View的所有输入框
    var subtextFieldViews: [TextFieldView] {
        var inputViews: [TextFieldView] = []
        if let textField = self as? TextFieldView {
            inputViews.append(textField)
        } else if !self.subviews.isEmpty {
            self.subviews.forEach { view in
                inputViews.append(contentsOf: view.subtextFieldViews)
            }
        }
        return inputViews
    }
}
extension Array where Element: TextFieldView {
    /// 列出当前View的所有输入框 并按照 是否isVertical 参照self的坐标系给输入框排序
    func sortedByPosition(isVertical: Bool = true) -> [TextFieldView] {
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
    func sortedByTag() -> [TextFieldView] {
        return self.sorted(by: { $0.tag < $1.tag })
    }
    
    var firstResponder: TextFieldView? {
        return self.first(where: { $0.isFirstResponder })
    }
}
