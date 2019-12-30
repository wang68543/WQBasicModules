//
//  UITableView+Extensions.swift
//  Pods-WQBasicModules_Example
//
//  Created by iMacHuaSheng on 2019/12/30.
//

import UIKit
public extension UITableView {
    /// 隐藏最后一个的分割线
    /// - Parameters:
    ///   - indexPath: 路径
    ///   - padding: 分割线距离左边的距离
    func hideLastSeparator(_ indexPath: IndexPath, with padding: CGFloat = .zero) -> UIEdgeInsets {
        var inset: UIEdgeInsets
        if indexPath.row == self.numberOfRows(inSection: indexPath.section) - 1 {
           inset = UIEdgeInsets(top: 0, left: self.bounds.width, bottom: 0, right: 0)
        } else {
            if padding == .zero {
                return .zero
            } else {
                inset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)
            }
        }
        return inset
    }
    
    /// 隐藏最后没有数据的分割线
    func hideFooterSeparator() {
        self.tableFooterView = UIView()
    }
}
