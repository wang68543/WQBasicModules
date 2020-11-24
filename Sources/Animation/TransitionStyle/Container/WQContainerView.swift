//
//  WQContainerView.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/5.
//

import Foundation
import UIKit
//https://blog.csdn.net/yzl826839001/article/details/51280829 解决transform引起的布局动画
public class WQContainerView: UIView {
    var currentView: UIView? {
        return self.subviews.last
    }
    public override func addSubview(_ view: UIView) {
        super.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let left = view.leftAnchor.constraint(equalTo: self.leftAnchor)
        let right = view.rightAnchor.constraint(equalTo: self.rightAnchor)
        let top = view.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([left,top,right,bottom])
    }
    
    public func sizeThatFits(_ view: UIView? = nil) -> CGSize {
        if view == nil && !self.bounds.isEmpty { return self.bounds.size }
        guard let subView = view ?? self.subviews.first else { return .zero }
        return subView.modalSize
    }
 
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        guard !self.bounds.isEmpty else { return }
//        guard let subView = self.subviews.first else { return }
//
//        subView.bounds = self.bounds
//        let anchorPoint = subView.layer.anchorPoint
//        subView.center = CGPoint(x: anchorPoint.x * self.bounds.width, y: anchorPoint.y * self.bounds.height)
//    }
}
