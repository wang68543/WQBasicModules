//
//  UISearchBar+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/10/22.
//

import Foundation
public extension UISearchBar {
    /// SwifterSwift: Text field inside search bar (if applicable).
       var textField: UITextField? {
           if #available(iOS 13.0, *) {
               return searchTextField
           }
           let subViews = subviews.flatMap { $0.subviews }
           guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
               return nil
           }
           return textField
       }

       /// SwifterSwift: Text with no spaces or new lines in beginning and end (if applicable).
       var trimmedText: String? {
           return text?.trimmingCharacters(in: .whitespacesAndNewlines)
       }
}
