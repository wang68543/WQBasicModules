//
//  PanView.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/3/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class PanView: UIView {
    var panBehavior: WQPanBehavior?
    var animator: UIDynamicAnimator = UIDynamicAnimator()
    var targetFrameMinY: [CGFloat] = []
    private var targetCenterY: [CGFloat] = []
    weak var panMoveDelegate: WQPanViewable?
    var panBounce: Bool = false // 超过临界值之后是否继续向上滑
    var shouldScrollInScroll: Bool = true
    private var offset: CGPoint = .zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        panGR.delegate = self
        self.addGestureRecognizer(panGR)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let midH = self.frame.height * 0.5
        self.targetCenterY = targetFrameMinY.map({ $0 + midH}).sorted(by: {$0 < $1})
        if self.shouldScrollInScroll {

//            let scrollViews = self.subviews.flatMap($0.subViews)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension PanView {
    func allSubViews() {
//        self.subviews.forEach(<#T##body: (UIView) throws -> Void##(UIView) throws -> Void#>)
    }
//    func findSubViews(for view: UIView) -> [UIView] {
//        var views: [UIView] = []
////        views.append(view.subviews)
//        
//    }
    func addObserver(for scrollView: UIScrollView) {

    }
    @objc func panAction(_ sender: UIPanGestureRecognizer) {
        guard self.targetCenterY.count > 1 else { return }
        let point = sender.translation(in: self.superview)
        let minCenterY = self.targetCenterY.first!
        let maxCenterY = self.targetCenterY.last!
        let toY = self.center.y + point.y
        self.center = CGPoint(x: self.center.x, y: max(min(toY, maxCenterY), minCenterY))
        sender.setTranslation(.zero, in: self.superview)
        if sender.state == .began {
            self.willBeginDragging()
        } else if sender.state == .ended {
            var velocity = sender.velocity(in: self.superview)
            let minY = self.targetCenterY.filter({ $0 < toY }).min(by: {toY - $0 < toY - $1}) ?? self.targetCenterY.first!
            let maxY = self.targetCenterY.filter({ $0 > toY }).min(by: {$0 - toY < $1 - toY}) ?? self.targetCenterY.last!
            velocity.x = 0
            var tatgetOffsetY: CGFloat
            if velocity.y < 0 {// 向上滑
                if toY - minY < (maxY - minY) * 0.3  || abs(velocity.y) > 100 { // 达到上半部分
                    tatgetOffsetY = self.targetCenterY.first!
                } else { // 否则复位
                    tatgetOffsetY = self.targetCenterY.last!
                }
            } else { // 向下滑
                if minY - toY < (maxY - minY) * 0.3 || abs(velocity.y) > 100 {
                    tatgetOffsetY = self.targetCenterY.last!
                } else {
                    tatgetOffsetY = self.targetCenterY.first!
                }
            }
            self.willEndDragging(velocity, targetCenterY: tatgetOffsetY)
        }
    }

    func willBeginDragging() {
        self.animator.removeAllBehaviors()
    }
    func willEndDragging(_ velocity: CGPoint, targetCenterY: CGFloat) {
        var panBehavior: WQPanBehavior
        if let pan = self.panBehavior {
            panBehavior = pan
            self.panBehavior = pan
        } else {
            let pan = WQPanBehavior(with: self)
            panBehavior = pan
        }
        panBehavior.targetPoint = CGPoint(x: self.frame.midX, y: targetCenterY)
        panBehavior.velocity = velocity
        self.animator.addBehavior(panBehavior)
    }
}
extension PanView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let otherView = otherGestureRecognizer.view,
            otherView.isKind(of: UIScrollView.self) {
            return true
        } else {
            return false
        }
    }
}
