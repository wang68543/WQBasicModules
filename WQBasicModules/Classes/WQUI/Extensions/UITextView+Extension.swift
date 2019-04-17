//
//  UITextView+Extension.swift
//  Pods-WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/4/17.
//

import Foundation
public extension UITextView {
    //textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String)
    /// 限制最长输入字符串
    func shouldChange(_ limitLength: Int,  charactersIn  range: NSRange, replacementString string: String) -> Bool {
        // range 为将要被改变的原有输入框里面字符的范围(也就是光标选中的范围)
        //1.输入跟粘贴 都是 lenth为0 但是 replacementString有值 不为空 一次粘贴多个字符 lenth也为0
        //2.删除 就是string为空 一次删除多个 lenth就为删除的个数
        //3.替换 lenth为被替换字符串的长度 replacementString为将要替换的字符串
        if string.isEmpty { // 删除
            return true
        } else if var text = self.text {
            let start = text.index(text.startIndex, offsetBy: range.location)
            let end = text.index(start, offsetBy: range.length)
            let changeRange = Range<String.Index>(uncheckedBounds: (lower: start, upper: end))
            text = text.replacingCharacters(in: changeRange, with: string)
            if text.count > limitLength {
                self.text = String(text.prefix(limitLength))
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
}
