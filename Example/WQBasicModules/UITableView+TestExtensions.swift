//
//  UITableView+TestExtensions.swift
//  WQBasicModules_Example
//
//  Created by WQ on 2020/5/9.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
extension UITableView {
    func test_lastSeparatorSingleLine(lineColor: UIColor?, edge: UIEdgeInsets = .zero) {
          let width = self.frame.width == 0 ? UIScreen.main.bounds.width : self.frame.width
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
          let color = lineColor ?? self.separatorColor ?? UIColor.groupTableViewBackground
          let line = UIView()
          line.backgroundColor = color
            footerView.autoresizingMask = .flexibleWidth
          line.translatesAutoresizingMaskIntoConstraints = false
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
