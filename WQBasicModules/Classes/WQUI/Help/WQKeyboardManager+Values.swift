//
//  WQKeyboardManager+Values.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2019/1/27.
//

import Foundation
public extension WQKeyboardManager {
    /// 为nil 表示没有为空的 为空则表示没有对应的值
    func emptyValueMessageWithKey() -> String? {
        var message: String?
        for textFieldView in self.textFieldViews {
            if let textField = textFieldView as? UITextField {
                if let text = textField.text, !text.isEmpty { } else {
                    if let textKey = textField.textKey {
                        message = self.emptyKeyMessages[textKey] ?? ""
                    } else {
                        message = ""
                    }
                    break
                }
            } else if let textView = textFieldView as? UITextView {
                if let text = textView.text, !text.isEmpty { } else {
                    if let textKey = textView.textKey {
                        message = self.emptyKeyMessages[textKey] ?? ""
                    } else {
                        message = ""
                    }
                    break
                }
            }
        }
        return message
    }
    func emptyValueMessageWithTag() -> String? {
        var emptyTag: Int?
        for textFieldView in self.textFieldViews {
            if let textField = textFieldView as? UITextField {
                if let text = textField.text, !text.isEmpty { } else {
                    emptyTag = textFieldView.tag
                }
            } else if let textView = textFieldView as? UITextView {
                if let text = textView.text, !text.isEmpty { } else {
                    emptyTag = textFieldView.tag
                }
            }
        }
        if let tag = emptyTag {
            return self.emptyTagMessages[tag] ?? ""
        }
        return nil
    }
    /// 批量给输入框数组设置key
    func configTextKeys(_ keys: [String]) {
        self.textFieldViews.configTextKeys(keys)
    }
    func value(forTextFieldView key: String) -> String? {
        return self.textFieldViews.value(for: key)
    }
    func value(forTextFieldView tag: Int) -> String? {
        return self.textFieldViews.value(for: tag)
    }
    func setValue(_ value: String, forTextFieldView key: String) {
        self.textFieldViews.setValue(value, for: key)
    }
    func setValue(_ value: String, forTextFieldView tag: Int) {
        self.textFieldViews.setValue(value, for: tag)
    }
    func isEmpty(forTextFieldView key: String) -> Bool {
        return self.textFieldViews.isEmpty(forTextFieldView: key)
    }
    func isEmpty(forTextFieldView tag: Int) -> Bool {
        return self.textFieldViews.isEmpty(forTextFieldView: tag)
    }
}
internal extension WQKeyboardManager {
    func clearTextFieldViewsAssociated() {
        self.textFieldViews.forEach { input in
            if let textView = input as? UITextView {
                textView.textKey = nil
            } else if let textField = input as? UITextField {
                textField.textKey = nil
            }
        }
    }
}
extension Array where Element: TextFieldView {
    func configTextKeys(_ keys: [String]) {
        for idx in 0 ..< Swift.min(self.count, keys.count) {
            let textFieldView = self[idx]
            let key = keys[idx]
            if let textField = textFieldView as? UITextField {
                textField.textKey = key
            } else if let textView = textFieldView as? UITextView {
                textView.textKey = key
            }
        }
    }
    func valuesWithTag() -> [Int: String] {
        var values: [Int: String] = [:]
        self.forEach { textFieldView in
            if let textField = textFieldView as? UITextField {
                values[textField.tag] = textField.text ?? ""
            } else if let textView = textFieldView as? UITextView {
                values[textView.tag] = textView.text ?? ""
            }
        }
        return values
    }
    func valuesWithKey() -> [String: String] {
        var values: [String: String] = [:]
        self.forEach { textFieldView in
            if let textField = textFieldView as? UITextField,
                let key = textField.textKey {
                values[key] = textField.text ?? ""
            } else if let textView = textFieldView as? UITextView,
                let key = textView.textKey {
                values[key] = textView.text ?? ""
            }
        }
        return values
    }
    func isEmpty(forTextFieldView key: String) -> Bool {
        guard let text = self.value(for: key) else {
            return true
        }
        return text.isEmpty
    }
    func isEmpty(forTextFieldView tag: Int) -> Bool {
        guard let text = self.value(for: tag) else {
            return true
        }
        return text.isEmpty
    }
    func setValue(_ value: String, for tag: Int) {
        guard let textFieldView = self.first(for: tag) else { return }
        if let textField = textFieldView as? UITextField {
            textField.text = value
        } else if let textView = textFieldView as? UITextView {
            textView.text = value
        }
    }
    func setValue(_ value: String, for key: String) {
        guard let textFieldView = self.first(for: key) else { return }
        if let textField = textFieldView as? UITextField {
            textField.text = value
        } else if let textView = textFieldView as? UITextView {
            textView.text = value
        }
    }
    func value(for key: String) -> String? {
        guard let textFieldView = self.first(for: key) else { return nil }
        if let textField = textFieldView as? UITextField {
            return textField.text
        } else if let textView = textFieldView as? UITextView {
            return textView.text
        }
        return nil
    }
    func value(for tag: Int) -> String? {
        guard let textFieldView = self.first(for: tag) else { return nil }
        if let textField = textFieldView as? UITextField {
            return textField.text
        } else if let textView = textFieldView as? UITextView {
            return textView.text
        }
        return nil
    }
    func first(for key: String) -> TextFieldView? {
        return self.first(where: { textFieldView -> Bool in
            if let textField = textFieldView as? UITextField {
               return textField.textKey == key
            } else if let textView = textFieldView as? UITextView {
               return textView.textKey == key
            }
            return false
        })
    }
    func first(for tag: Int) -> TextFieldView? {
        return self.first(where: { $0.tag == tag })
    }
}

private var bindTextKey: Void?

public extension UITextField {
    var textKey: String? {
        set {
            objc_setAssociatedObject(self, &bindTextKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &bindTextKey) as? String
        }
    }
}

public extension UITextView {
    var textKey: String? {
        set {
            objc_setAssociatedObject(self, &bindTextKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &bindTextKey) as? String
        }
    }
}
