//
//  UIButton+CountDwon.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/11/4.
//

import UIKit

// MARK: - --支持简单的倒计时定义
public extension NumberFormatter {
    convenience init(countDownFormat pre: String?, suf: String?, formatWidth: Int = 2) {
        self.init()
        self.positivePrefix = pre
        self.positiveSuffix = suf
        self.formatWidth = 2
    }
}
// MARK: - -- Count Down
public extension UIButton {
    
    /// 根据设定的参数每隔一段时间执行一次
    /// - Parameters:
    ///   - UIButton: 当前对象
    ///   - UInt: 剩余数量
    typealias IntervalExecute = (UIButton, UInt) -> Void
    
    /// 根据设定的参数每隔一段时间执行一次
    /// - Parameters:
    ///   - UIButton: 当前对象
    ///   - Bool: 是否是正常结束
    /// - Returns: 背景颜色、标题是否恢复到倒计时之前的状态
    typealias CountDownCompletion = (UIButton, Bool) -> Bool
    /// 当前的状态
    var currentControlState: UIControl.State {
        var state: UIControl.State
        if !self.isEnabled {
            state = .disabled
        } else if self.isHighlighted {
            state = .highlighted
        } else if self.isSelected {
            state = .selected
        } else {
            state = .normal
        }
        return state
    }
    
    /// 倒计时是否可以中途中断 Default `false`
    var isCanCancel: Bool {
        set {
            objc_setAssociatedObject(self, CountDownKeys.isCanCancel, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, CountDownKeys.isCanCancel) as? Bool ?? false
        }
    }
    /// 倒计时
    ///
    /// - Parameters:
    ///   - formater: 倒计时的时候格式化标题
    ///   - color: 倒计时时候的标题颜色 (为空的时候使用.normal标题色)
    ///   - completion: 倒计时完成回调
    func countDown(total: UInt,
                   formater: NumberFormatter,
                   color: UIColor? = nil,
                   completion: CountDownCompletion? = nil) {
        let titleColor = color ?? self.titleColor(for: .normal)
        let currentState = self.currentControlState
        let excute: IntervalExecute = { sender, secs in
            let title = formater.string(from: NSNumber(value: secs))
            sender.setTitle(title, for: currentState)
        }
        self.countDown(total, interval: 1, execute: excute, completion: completion)
        self.setTitleColor(titleColor, for: currentState)
    }
    /// 倒计时按钮
    ///
    /// - Parameters:
    ///   - count: 开始倒计时的数量
    ///   - interval: 重复的间隔,单位时间秒数
    ///   - execute: 间隔回调
    ///   - completion: 终止或者总数小于0就倒计时终止
    func countDown(_ count: UInt,
                   interval: Double = 1,
                   execute: @escaping IntervalExecute,
                   completion: CountDownCompletion?) { //末尾连续两个闭包 最后一个不能 默认为nil 会造成Xcode把倒数第二个闭包当做尾随闭包调用从而出现语法错误
        self.countDownCompletion = completion
        if self.source != nil {
            stopCountDown(false)
        } else {
            self.totalCount = count - 1 //先减一
            self.execute = execute
            self.saveCurrentStatues()
            startTimer(interval)
        }
    }
    ///取消倒计时
    func cancelCountDown() {
        self.stopCountDown(true, isFinshed: false)
    }
    private func startTimer(_ interval: Double) {
        let source: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        source.schedule(wallDeadline: DispatchWallTime.now(), repeating: interval)
        source.setEventHandler { [weak self] in
            guard let weakSelf = self else {
                return
            }
            var total = weakSelf.totalCount
            if total <= 0 {
                weakSelf.stopCountDown(true)
            } else { 
                weakSelf.execute?(weakSelf, total)
                total -= 1
                weakSelf.totalCount = total
            }
        }
        self.source = source
        source.resume()
    }
    private func stopCountDown(_ flag: Bool, isFinshed: Bool = true) {
        var shouldRecovery = true
        if let completion = self.countDownCompletion {
            shouldRecovery = completion(self, isFinshed)
        }
        if shouldRecovery {
            recoveryBeforeStatues()
        }
        clearAssociatedObjects()
    }
}
// MARK: - -- Associated Objects
private extension UIButton {
    var source: DispatchSourceTimer? {
        set {
            objc_setAssociatedObject(self, CountDownKeys.timerSource, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, CountDownKeys.timerSource) as? DispatchSourceTimer
        }
    }
   var totalCount: UInt {
        set {
            //使用copy策略代替assign策略避免在32位机器上没有Tagged Pointer 而造成坏内存访问
            #if arch(arm64) || arch(x86_64)
            objc_setAssociatedObject(self, CountDownKeys.totalCount, newValue, .OBJC_ASSOCIATION_ASSIGN)
            #else
            objc_setAssociatedObject(self, CountDownKeys.totalCount, newValue, .OBJC_ASSOCIATION_COPY)
            #endif
        }
        get { 
           return objc_getAssociatedObject(self, CountDownKeys.totalCount) as? UInt ?? 0
        }
    }
    var countDownCompletion: CountDownCompletion? {
        set {
            objc_setAssociatedObject(self, CountDownKeys.completion, newValue, .OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, CountDownKeys.completion) as? CountDownCompletion
        }
    }
    
    var execute: IntervalExecute? {
        set {
            objc_setAssociatedObject(self, CountDownKeys.execute, newValue, .OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, CountDownKeys.execute) as? IntervalExecute
        }
    }
}
// MARK: - -- Before CountDown Status
fileprivate extension UIButton {
    struct CountDownKeys {
        static let timerSource = UnsafeRawPointer(bitPattern: "wq.button.countDown.timerSource".hashValue)!
        static let totalCount = UnsafeRawPointer(bitPattern: "wq.button.countDown.totalCount".hashValue)!
        static let completion = UnsafeRawPointer(bitPattern: "wq.button.countDown.completion".hashValue)!
        static let execute = UnsafeRawPointer(bitPattern: "wq.button.countDown.execute".hashValue)!
        static let isCanCancel = UnsafeRawPointer(bitPattern: "wq.button.countDown.isCanCancel".hashValue)!
        static let beforeStatus = UnsafeRawPointer(bitPattern: "wq.button.countDown.beforeStatus".hashValue)!
    }
    
    final class StoredStatus {
        var state: UIControl.State = .normal
        var backgroundColor: UIColor?
        var backgroundImage: UIImage?
        var title: String?
        var image: UIImage?
        var titleColor: UIColor?
        var titleShadowColor: UIColor?
        var attributedTitle: NSAttributedString?
        var borderWidth: CGFloat = 0
        var borderColor: CGColor?
        var cornerRadius: CGFloat = 0
    }
    
    private var status: StoredStatus? {
        set {
            objc_setAssociatedObject(self, CountDownKeys.beforeStatus, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, CountDownKeys.beforeStatus) as? StoredStatus
        }
    }
    /// 存储当前的状态
    func saveCurrentStatues() {
        let status = StoredStatus()
        if !self.isCanCancel {
            self.isUserInteractionEnabled = false
        }
        status.state = self.currentControlState
        status.backgroundImage = self.currentBackgroundImage
        status.attributedTitle = self.currentAttributedTitle
        status.title = self.currentTitle
        status.image = self.currentImage
        status.titleColor = self.currentTitleColor
        status.titleShadowColor = self.currentTitleShadowColor
        status.backgroundColor = self.backgroundColor
        status.borderWidth = self.layer.borderWidth
        status.borderColor = self.layer.borderColor
        status.cornerRadius = self.layer.cornerRadius
        self.status = status
    } 
    /// 恢复之前的状态
    func recoveryBeforeStatues() {
        if !self.isCanCancel { // 不管怎样 需要先恢复能用
            self.isUserInteractionEnabled = true
        }
        guard let status = self.status  else {
            return
        }
        let state = status.state
        self.setImage(status.image, for: state)
        self.setBackgroundImage(status.backgroundImage, for: state)
        self.setAttributedTitle(status.attributedTitle, for: state)
        self.setTitle(status.title, for: state)
        self.setTitleColor(status.titleColor, for: state)
        self.setTitleShadowColor(status.titleShadowColor, for: state)
        self.backgroundColor = status.backgroundColor
        self.layer.borderWidth = status.borderWidth
        self.layer.borderColor = status.borderColor
        self.layer.cornerRadius = status.cornerRadius
        if !self.isCanCancel {
            self.isEnabled = true
        } else {
            if status.state == .selected {
                self.isSelected = true
            } else if status.state == .highlighted {
                self.isHighlighted = true
            } else {
                self.isHighlighted = false
                self.isSelected = false
            }
        }
    }
    /// 清除关联对象
    func clearAssociatedObjects() {
        self.status = nil
        if let source = self.source,
            !source.isCancelled {
            source.cancel()
        }
        self.source = nil
        self.execute = nil
        self.countDownCompletion = nil
        objc_setAssociatedObject(self, CountDownKeys.isCanCancel, nil, .OBJC_ASSOCIATION_ASSIGN)
        objc_setAssociatedObject(self, CountDownKeys.totalCount, nil, .OBJC_ASSOCIATION_ASSIGN)
    }
}  
//fileprivate extension UIButton {
//    static let keyCopyButton = UnsafeRawPointer(bitPattern: "wq.button.countDown.copyButton".hashValue)!
//    var copyButton: UIButton? {
//        set {
//            objc_setAssociatedObject(self, UIButton.keyCopyButton, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//        get {
//            if let copyBtn = objc_getAssociatedObject(self, UIButton.keyCopyButton) as? UIButton {
//                return copyBtn
//            } else {
//                let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
//                let copyView = NSKeyedUnarchiver.unarchiveObject(with: archivedData) as? UIButton
//                copyView?.isUserInteractionEnabled = false
//                self.copyButton = copyView
//                return copyView
//            }
//        }
//    }
//}
