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
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
////        self.translatesAutoresizingMaskIntoConstraints = true
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//        public override func addSubview(_ view: UIView) {
//            super.addSubview(view)
//            self.translatesAutoresizingMaskIntoConstraints = false
//            view.translatesAutoresizingMaskIntoConstraints = false
////            let size: CGSize
//            if view.bounds.isEmpty {
//                let size = view.modalSize
//                view.bounds =  CGRect(origin: .zero, size: size)
//            }
////            else {
////                size = view.bounds.size
////            }
////            let anchorPoint = view.layer.anchorPoint
////            view.center = CGPoint(x: anchorPoint.x * size.width, y: anchorPoint.y * size.height)
////////        view.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
////            let left = view.leftAnchor.constraint(equalTo: self.leftAnchor)
////            let right = view.rightAnchor.constraint(equalTo: self.rightAnchor)
////            let top = view.topAnchor.constraint(equalTo: self.topAnchor)
////            let bottom = view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//////
////            NSLayoutConstraint.activate([left,right,top,bottom])
////            self.setNeedsUpdateConstraints()
////            self.updateConstraintsIfNeeded()
//    }
    public func sizeThatFits(_ view: UIView? = nil) -> CGSize {
        if view == nil && !self.bounds.isEmpty { return self.bounds.size }
        guard let subView = view ?? self.subviews.first else { return .zero }
        return subView.modalSize
    }
//    public override var transform: CGAffineTransform {
//        didSet {
//            currentView?.transform = transform
//        }
//    }
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        if let view = currentView {
//            let size = view.bounds.size
//            let anchorPoint = view.layer.anchorPoint
//            view.center = CGPoint(x: anchorPoint.x * size.width, y: anchorPoint.y * size.height)
//        }
//    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard !self.bounds.isEmpty else { return }
        guard let subView = self.subviews.first else { return }

        subView.bounds = self.bounds
        let anchorPoint = subView.layer.anchorPoint
        subView.center = CGPoint(x: anchorPoint.x * self.bounds.width, y: anchorPoint.y * self.bounds.height)
    }
}
