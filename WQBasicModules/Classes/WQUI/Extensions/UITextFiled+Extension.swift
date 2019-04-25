//  UITextFiled+Extension.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/4/17.
//

import UIKit

public extension UITextField {
    struct AssociatedKeys {
        static let maxInputLengthKey = UnsafeRawPointer(bitPattern: "wq.textFiled.maxInputLength".hashValue)! 
    }
    
    var maxInputLength: Int? {
        set {
            if newValue == nil {
                self.removeObserver()
            } else {
                self.addObserver()
            }
            objc_setAssociatedObject(self, AssociatedKeys.maxInputLengthKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
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
