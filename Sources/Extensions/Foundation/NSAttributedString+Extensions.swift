//
//  NSAttributedString+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/12/30.
//

import Foundation

public extension NSAttributedString {
    
    /// label 宽度固定 文字均匀分布
    /// - Parameters:
    ///   - string: 文字
    ///   - width: 控件宽度
    ///   - attrs: 文字属性
    convenience init(spaceBetween string: String, width: CGFloat,
                     attributes attrs: [NSAttributedString.Key: Any]? = nil) {
        if string.count > 1 {
            let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .truncatesLastVisibleLine]
            let textSize = NSString(string: string)
                .boundingRect(with: maxSize,
                              options: options,
                              attributes: attrs,
                              context: nil).size
            let margin = (width - textSize.width) / CGFloat(string.count - 1)
            if margin > 0 {
                let textAttr = NSMutableAttributedString(string: string, attributes: attrs)
                textAttr.addAttribute(.kern, value: margin, range: NSRange(location: 0, length: string.count - 1))
                self.init(attributedString: textAttr)
            } else {
                self.init(string: string, attributes: attrs)
            }
        } else {
            self.init(string: string, attributes: attrs)
        }
    }
}
