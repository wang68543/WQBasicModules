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
    /// 设置最后一个cell的分割线
    func lastSeparatorSingleLine(lineColor: UIColor?, edge: UIEdgeInsets = .zero) {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 0.5))
        let color = lineColor ?? self.separatorColor ?? UIColor.groupTableViewBackground
        let line = UIView()
        line.backgroundColor = color
        footerView.addSubview(line)
        var layoutConstraints: [NSLayoutConstraint] = []
        if #available(iOS 9.0, *) {
            layoutConstraints.append(line.topAnchor.constraint(equalTo: footerView.topAnchor))
            layoutConstraints.append(line.bottomAnchor.constraint(equalTo: footerView.bottomAnchor))
            layoutConstraints.append(line.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: edge.left))
            layoutConstraints.append(line.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -edge.right))
        } else {
            let left = NSLayoutConstraint(item: line, attribute: .left, relatedBy: .equal, toItem: footerView, attribute: .left, multiplier: 1.0, constant: edge.left)
            let right = NSLayoutConstraint(item: line, attribute: .right, relatedBy: .equal, toItem: footerView, attribute: .right, multiplier: 1.0, constant: -edge.right)
            let top = NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: footerView, attribute: .top, multiplier: 1.0, constant: 0)
            let bottom = NSLayoutConstraint(item: line, attribute: .bottom, relatedBy: .equal, toItem: footerView, attribute: .bottom, multiplier: 1.0, constant: 0)
            layoutConstraints.append(left)
            layoutConstraints.append(right)
            layoutConstraints.append(top)
            layoutConstraints.append(bottom)
        }
        NSLayoutConstraint.activate(layoutConstraints)
        self.tableFooterView = footerView
        
    }
}
