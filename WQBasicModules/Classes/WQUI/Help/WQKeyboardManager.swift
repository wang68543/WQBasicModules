//
//  WQKeyboardManager.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/1/15.
//

import Foundation
/// 输入框类型
public typealias TextFieldView = UIView & UITextInput
public final class WQKeyboardManager: NSObject {
    public var keyboardDistanceFromtextFieldView: CGFloat = 10
    public var isEnabled: Bool = true
    public var sortTextFieldViewsBy: Array<TextFieldView>.TextFieldViewSorted = .byVertical
    unowned let view: UIView
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
    public var touchResignedGestureIgnoreClasses: [AnyClass] = [UIControl.self, UINavigationBar.self]
    /// view 开始移动之前的位置 (如果moveView是ScrollView 则记录offset)
    private var initialPosition: CGPoint = .invaildPosition
    /// 懒加载 有成为响应者的输入框这里才会获取当前页面的输入框
    private lazy var textFieldViews: [TextFieldView] = self.textResponders()
    private var _textFieldView: TextFieldView?
    private var _keyboardShowing: Bool = false
    private var _kbShowNotification: Notification?
    private var _kbFrame: CGRect = .zero
    private weak var textFieldDelegate: UITextFieldDelegate? //用于拦截当前响应者的代理 处理下一个
    private lazy var safeAreaInsets: UIEdgeInsets = { // 保存初始的safeAreaInsets
        if #available(iOS 11.0, *) {
           return self.view.safeAreaInsets
        } else {
            return .zero
        }
    }()
    
    public init(_ view: UIView) {
        self.view = view
        super.init()
        self.registerAllNotifications()
    }
    deinit {
        self.unregisterAllNotification()
    }
}


// MARK: - --Interface
public extension WQKeyboardManager {
    func reloadTextFieldViews() {
        textFieldViews = self.textResponders()
    }
    func canGoNext() -> Bool {
        guard let index = self.textFieldViews.firstIndex(of: _textFieldView) else { return false }
        if index == self.textFieldViews.count - 1 { return false } //最后一个
        return true
    }
    
    /// 移动到下一个输入框
    ///
    /// - Returns: 是否跳转成功
    @discardableResult
    func goNext() -> Bool {
        if canGoNext(),
           let index = self.textFieldViews.firstIndex(of: _textFieldView),
           index < self.textFieldViews.count - 1 {
            let next = self.textFieldViews[index + 1]
           return next.becomeFirstResponder()
        } else {
            self.recoveryPoistion()
            return false
        }
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
        if let view = self.view.containingController?.view {
            let tapGR = UITapGestureRecognizer()
            tapGR.delegate = self
            view.addGestureRecognizer(tapGR)
            tapGesture = tapGR
        } else {
            debugPrint("请先将view添加到Controller的树形结构中")
        }
    }
    func textResponders() -> [TextFieldView] {
        var inputViews: [TextFieldView] = []
        inputViews = self.view.subtextFieldViews
            .filter({ canBecomeFirstResponder(for: $0) })
        return inputViews.sorted(by: self.sortTextFieldViewsBy)
    }
    /// 确认是否可以响应
    func canBecomeFirstResponder(for view: TextFieldView) -> Bool {
        
        var canBecome: Bool = view.canBecomeFirstResponder
        if let textView = view as? UITextView {
            canBecome = textView.isEditable
        } else if let textField = view as? UITextField {
            //canBecomeFirstResponder 会调用代理textFieldShouldBeginEditing
            canBecome = textField.isEnabled
        }
        return canBecome && !view.isHidden && view.alpha > 0.01 && view.isUserInteractionEnabled
    }
    /// 判断响应的对象是否是当前的view的树形图中
    func isInViewHierarchy(for textFieldView: TextFieldView) -> Bool {
        var isInHierarchy: Bool = false
        var textSuperView = textFieldView.superview
        while let superView = textSuperView,
             !isInHierarchy {
                isInHierarchy = self.view === superView
                textSuperView = textSuperView?.superview
        }
        return isInHierarchy
    }
    func layoutSuperViewIfNeed() {
        self.view.superview?.layoutIfNeeded()
    }
    func recoveryPoistion() {
        guard self.initialPosition != .invaildPosition else {
            return
        }
        self.view.layer.position = initialPosition
        UIView.animate(withDuration: animationDuration, delay: 0, options: [animationCurve, .beginFromCurrentState], animations: {
            self.layoutSuperViewIfNeed()
        }, completion: nil)
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
        if let textView = _textFieldView {
            textView.resignFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        guard initialPosition != .zero else {
            //没有记录过移动位置之前的位置 所以不需要移动
            return
        }
        if sender.state == .ended {
           self.recoveryPoistion()
        }
    }
    func textFieldViewDidBeginEditing(_ note: Notification) {
//        debugPrint(#function, note.object!)
        guard let inputView = note.object as? TextFieldView,
        self.isEnabled,
        self.isInViewHierarchy(for: inputView) else {
            _textFieldView = nil
            return
        }
        if let textField = inputView as? UITextField {
            textFieldDelegate = textField.delegate
            textField.delegate = self
        }
        _textFieldView = inputView
        reloadTextFieldViews()
        self.textFieldViews.dropLast().forEach { textFieldView in
            if let textField = textFieldView as? UITextField {
                textField.returnKeyType = .next
            } else if let textView = textFieldView as? UITextView {
                textView.returnKeyType = .next
            }
        }
        if let textField = self.textFieldViews.last as? UITextField {
            textField.returnKeyType = .done
        } else if let textView = self.textFieldViews.last as? UITextView {
            textView.returnKeyType = .done
        }
        if _keyboardShowing,
            initialPosition != .invaildPosition {
            optimizedAdjustPosition()
        }
    }
    func textFieldViewDidEndEditing(_ note: Notification) {
//        debugPrint(#function, note.object!)
        if let textField = _textFieldView as? UITextField,
            let delegate = textFieldDelegate {
            textField.delegate = delegate //还原
        }
        _textFieldView = nil
        textFieldDelegate = nil
    }
    func keyboardWillShow(_ note: Notification) {
//        debugPrint(#function)
        initialPosition = self.view.layer.position
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
        if duration != 0.0 { animationDuration = duration }
        let oldKBFrame = _kbFrame
        _kbFrame = kbFrame
        guard self.isEnabled else { debugPrint("已禁用"); return }
        if oldKBFrame != kbFrame,
            _textFieldView != nil {
            self.optimizedAdjustPosition()
        }
    }
    func keyboardDidShow(_ note: Notification) {
//        debugPrint(#function)
        guard self.isEnabled else { return }
        //If _textFieldView viewController is presented as formSheet,
        //then adjustPosition again because iOS internally update formSheet frame on keyboardShown.
        if _keyboardShowing == true,
            _textFieldView != nil,
            let controller = self.view.containingController,
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
        if duration != 0.0 { animationDuration = duration }
        guard self.isEnabled else { return }
        self.recoveryPoistion()
    }
    func keyboardDidHide(_ note: Notification) {
        debugPrint(#function)
        _kbFrame = .zero
    }
    func willChangeStatusBarOrientation(_ note: Notification) {
        // 待实现
    }
}
extension WQKeyboardManager {
    var keyWindow: UIWindow? {
        return self.view.window ?? UIApplication.shared.keyWindow
    }
    //swiftlint:disable function_body_length
    func optimizedAdjustPosition() {
        guard let inputView = _textFieldView,
            let superView = inputView.superview,
            let keyWindow = self.keyWindow else {
                _textFieldView = nil
                return
        }
        let textFrameInWindow = superView.convert(inputView.frame, to: keyWindow)
        var kbFrame = _kbFrame
        kbFrame.origin.y -= self.keyboardDistanceFromtextFieldView
        kbFrame.size.height += self.keyboardDistanceFromtextFieldView
        let move = kbFrame.minY - textFrameInWindow.maxY // 需要移动的距离
        guard move != 0 else { return } // == 0 无需移动
        if  let scrollView = self.view as? UIScrollView { //scrollview与键盘没有交集 滚动scrollView
            // 先移动 scrollView  再设置offset
            let insets = scrollView.contentInset
            let areas = self.safeAreaInsets
            let containerHeight = scrollView.frame.height - insets.top - insets.bottom - areas.top - areas.bottom
            var contentSize = scrollView.contentSize
            contentSize.height = max(containerHeight, contentSize.height) // scrollView 的contentSizeHeight ke可能为0
            let maxOffsetY = contentSize.height - containerHeight
            debugPrint("contentSize:\(contentSize),frame:\(self.view.frame)")
            debugPrint("maxPositionY:\(self.initialPosition.y),maxOffsetY:\(maxOffsetY)")
            let minOffsetY = -self.safeAreaInsets.top
            var poistion = scrollView.layer.position
            var offset = scrollView.contentOffset
            debugPrint("poistion:\(poistion),offset:\(offset)")
            var adjustMove = move
            if #available(iOS 11.0, *),
                areas.bottom > 0 && textFrameInWindow.maxY > UIScreen.main.bounds.height - areas.bottom {
                // 当输入框在底部非安全区域的时候 scrollView 会自动向上偏移bottom
                adjustMove += areas.bottom //少偏移一个safe区域
            }
            //notaTODO: view移动遵循原则: 上移底部边界不能大于键盘顶部边界 下移不能低于原始的位置
            if adjustMove < 0 { // 需要向上移
                // 当上移的时候 
                let moveViewFrameInWindow = self.view.superview?.convert(self.view.frame, to: keyWindow) ?? CGRect.zero
                let viewCanMoveHeight = max(moveViewFrameInWindow.maxY - kbFrame.minY, 0)
                poistion.y -= min(viewCanMoveHeight, abs(adjustMove))
                offset.y += max(abs(adjustMove) - viewCanMoveHeight, 0)
                debugPrint("viewCanMoveHeight:\(viewCanMoveHeight),move:\(move)")
                debugPrint("Old poistion:\(poistion),offset:\(offset)")
                offset.y = min(maxOffsetY, offset.y) // 最大不能超过可偏移的尺寸  最小不能小于minOffsetY
            } else { // 需要向下移动
                let downMaxMove = max(self.initialPosition.y - scrollView.layer.position.y, 0)
                poistion.y += min(downMaxMove, adjustMove)
                offset.y -= max(adjustMove - downMaxMove, 0)
                debugPrint("downMaxMove:\(downMaxMove),move:\(move)")
                debugPrint("poistion:\(poistion),offset:\(offset)")
                offset.y = max(offset.y, minOffsetY) // 最大不能超过可偏移的尺寸  最小不能小于minOffsetY
            }
            debugPrint("fixedOffset:\(offset)")
            debugPrint("==================================")
            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           options: [animationCurve, .beginFromCurrentState],
                           animations: {
                                if offset != scrollView.contentOffset {
                                    scrollView.contentOffset = offset
                                }
                                if poistion != scrollView.layer.position {
                                    scrollView.layer.position = poistion
                                }
            })
        } else {
            var position = self.view.layer.position
            position.y += move
            position.y = min(self.initialPosition.y, position.y) // 下移不能超过原始位置
            if self.view.layer.position != position {
                UIView.animate(withDuration: animationDuration,
                               delay: 0,
                               options: [animationCurve, .beginFromCurrentState],
                               animations: {
                                self.view.layer.position = position
                })
            }
        }
        
    }
}

// MARK: - --TextField Delegate
extension WQKeyboardManager: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let shouldBegin = textFieldDelegate?.textFieldShouldBeginEditing?(textField) {
            return shouldBegin
        } else {
            //  &&  textField.isUserInteractionEnabled && textField.isEnabled //会造成死循环
            return textField.alpha > 0.01 && !textField.isHidden
        }
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidBeginEditing?(textField)
    }
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       return textFieldDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidEndEditing?(textField)
    }
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textFieldDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textFieldDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return textFieldDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let shouldReturn = textFieldDelegate?.textFieldShouldReturn?(textField) {
            if !shouldReturn { //不能换行
                goNext()
            }
            return shouldReturn
        } else {
            goNext()
            return false
        }
    }
}
extension WQKeyboardManager: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else { return false }
        if self.touchResignedGestureIgnoreClasses.firstIndex(where: { touchView.isKind(of: $0) }) != nil {
            return false
        }
        return true
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
    public enum TextFieldViewSorted {
        case byVertical
        case byHorizontal
        case byTag
    }
    func sorted(by type: TextFieldViewSorted) -> [TextFieldView] {
        var textFieldViews: [TextFieldView]
        switch type {
        case .byVertical:
            textFieldViews = self.sortedByPosition(isVertical: true)
        case .byHorizontal:
            textFieldViews = self.sortedByPosition(isVertical: false)
        case .byTag:
            textFieldViews = self.sortedByTag()
        }
        return textFieldViews
    }
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
    func firstIndex(of element: TextFieldView?) -> Int? {
        guard let textFiledView = element else {
            return nil
        }
        return self.firstIndex(where: { $0 === textFiledView })
    }
}

fileprivate extension CGPoint {
    /// 随便给个数值 表示未初始化
    static let invaildPosition = CGPoint(x: -1.111_11, y: -2.222_22)
}
