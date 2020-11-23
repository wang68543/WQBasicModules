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
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//        public override func addSubview(_ view: UIView) {
//        super.addSubview(view)
//        view.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
//    }
    public func sizeThatFits(_ view: UIView? = nil) -> CGSize {
        if view == nil && !self.bounds.isEmpty { return self.bounds.size }
        guard let subView = view ?? self.subviews.first else { return .zero }
        return subView.modalSize
    }
 
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let subView = self.subviews.first else { return }
//        subView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
        subView.bounds = self.bounds
        let anchorPoint = subView.layer.anchorPoint
        subView.center = CGPoint(x: anchorPoint.x * self.bounds.width, y: anchorPoint.y * self.bounds.height)
    }
}
