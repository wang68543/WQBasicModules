//
//  UITextView+Extension.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/4/17.
//
#if canImport(UIKit) && !os(watchOS)
import Foundation
public extension UITextView {
    private struct AssociatedKeys {
        static let maxTextSizeKey = UnsafeRawPointer(bitPattern: "wq.textView.maxTextSize".hashValue)!
    }
    
    /// 当textview一次输入的文字过多的时候 前后跳动问题无法解决
    var maxTextSize: Int? {
        set {
            if newValue == nil {
                self.removeObserver()
            } else {
                self.addObserver()
            }
            #if arch(arm64) || arch(x86_64)
            objc_setAssociatedObject(self, AssociatedKeys.maxTextSizeKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            #else
            objc_setAssociatedObject(self, AssociatedKeys.maxTextSizeKey, newValue, .OBJC_ASSOCIATION_COPY)
            #endif 
        }
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.maxTextSizeKey) as? Int
        }
    }
    
    private func addObserver() {
        self.removeObserver()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
    }
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    //https://zltunes.github.io/2019/04/14/uitextview-max-length/
    @objc
    func textDidChange() {
        guard let length = self.maxTextSize,
            let string = self.text, string.count > length else {
                return
        }
        let preScroll = self.isScrollEnabled
        UIView.performWithoutAnimation {
            let range = self.selectedTextRange
            self.text = String(string.prefix(length))
            self.isScrollEnabled = false
            self.selectedTextRange = range
        }
        self.isScrollEnabled = preScroll
    }
}
public extension UITextView {
    /// 限制最长输入字符串
    func shouldChange(text limitCounts: Int, range: NSRange, replacementString string: String) -> Bool {
        // range 为将要被改变的原有输入框里面字符的范围(也就是光标选中的范围)
        //1.输入跟粘贴 都是 lenth为0 但是 replacementString有值 不为空 一次粘贴多个字符 lenth也为0
        //2.删除 就是string为空 一次删除多个 lenth就为删除的个数
        //3.替换 lenth为被替换字符串的长度 replacementString为将要替换的字符串
        if string.isEmpty { // 删除
            return true
        } else {
            let preLen = self.text.count - range.length
            return preLen + string.count <= limitCounts
        }
    }
    /// SwifterSwift: Scroll to the bottom of text view
    func scrollToBottom() {
        // swiftlint:disable:next legacy_constructor
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
    }
    
    /// SwifterSwift: Scroll to the top of text view
    func scrollToTop() {
        // swiftlint:disable:next legacy_constructor
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }
}
#endif
