//
//  WQContainerView.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/5.
//

import Foundation
import UIKit

public class WQContainerView: UIView {
//    public override func addSubview(_ view: UIView) {
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
