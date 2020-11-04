//
//  UITextField+Extension.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/4/17.
//

import UIKit
public extension UITextField {
    private struct AssociatedKeys {
        static let maxInputLengthKey = UnsafeRawPointer(bitPattern: "wq.textFiled.maxInputLength".hashValue)!
    }
    /// 限制最大输入长度
    var maxInputLength: Int? {
        set {
            if newValue == nil {
                self.removeObserver()
            } else {
                self.addObserver()
            }
            #if arch(arm64) || arch(x86_64)
            objc_setAssociatedObject(self, AssociatedKeys.maxInputLengthKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            #else
            objc_setAssociatedObject(self, AssociatedKeys.maxInputLengthKey, newValue, .OBJC_ASSOCIATION_COPY)
            #endif
        }
        get {
           return objc_getAssociatedObject(self, AssociatedKeys.maxInputLengthKey) as? Int
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
        guard let length = self.maxInputLength,
        let string = self.text, string.count > length else {
            return
        }
        let range = self.selectedTextRange
        self.text = String(string.prefix(length))
        self.selectedTextRange = range
    }
}
