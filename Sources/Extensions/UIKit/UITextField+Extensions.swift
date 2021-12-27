//
//  UITextField+Extension.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/4/17.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit
public extension UITextField {
    private struct AssociatedKeys {
        static let maxTextSizeKey = UnsafeRawPointer(bitPattern: "wq.textFiled.maxTextSize".hashValue)!
    }
    /// 限制最大输入长度
    var maxTextSize: Int? {
        set {
            if newValue == nil || maxTextSize == .zero {
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
            objc_getAssociatedObject(self, AssociatedKeys.maxTextSizeKey) as? Int
        }
    }
    
    private func addObserver() {
        self.removeObserver()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextField.textDidChangeNotification,
                                               object: self)
    }
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: self)
    }
    
    @objc
    func textDidChange() {
        guard let length = self.maxTextSize,
        let string = self.text, string.count > length else {
            return
        }
        let range = self.selectedTextRange
        self.text = String(string.prefix(length))
        if let textRange = range,
           let end = self.position(from: textRange.start, offset: 0) {
            self.selectedTextRange = self.textRange(from: textRange.start, to: end)
        }
    }
} 
#endif
