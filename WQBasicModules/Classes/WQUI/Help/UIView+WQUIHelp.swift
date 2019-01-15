//
//  UIView+WQUIHelp.swift
//  Pods
//
//  Created by WangQiang on 2019/1/14.
//

import Foundation

public extension WQModules where Base: UIView {
    var subTextInputs: [TextInputView] {
        return self.base.subTextInputs
    }
}
/// 输入框类型
public typealias TextInputView = UIView & UITextInput

extension UIView {
    /// 列出当前View的所有输入框
    var subTextInputs: [TextInputView] {
        var inputViews: [TextInputView] = []
        if let textInput = self as? TextInputView {
            inputViews.append(textInput)
        } else {
            if !self.subviews.isEmpty {
                self.subviews.forEach { view in
                    inputViews.append(contentsOf: view.subTextInputs)
                }
            }
        }
        return inputViews
    }
    
    /// 列出当前View的所有输入框 并按照 是否isVertical 参照self的坐标系给输入框排序
    func sortedTextInputs(isVertical: Bool = true) -> [TextInputView] {
        return self.subTextInputs.sorted(by: { input0, input1 in
            let frame0 = input0.convert(input0.frame, to: self)
            let frame1 = input1.convert(input1.frame, to: self)
            if isVertical {
               return frame0.minY < frame1.minY
            } else {
                return frame0.minX < frame1.minX
            }
         })
    }
}
