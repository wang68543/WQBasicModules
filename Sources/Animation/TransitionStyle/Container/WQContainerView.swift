//
//  WQContainerView.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/5.
//

import Foundation
import UIKit

public class WQContainerView: UIView {
    public override func addSubview(_ view: UIView) {
        super.addSubview(view)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        guard let subView = self.subviews.first else { return }
//        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////        subView.bounds = self.bounds
////        let anchorPoint = subView.layer.anchorPoint
////        subView.center = CGPoint(x: anchorPoint.x * self.bounds.width, y: anchorPoint.y * self.bounds.height)
//    }
}
