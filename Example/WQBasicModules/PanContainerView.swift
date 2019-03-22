//
//  PanContainerView.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/3/22.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
protocol WQPanViewable {
    func panViewDidOffset(_ panView: UIView)
    func panViewWillBeginDragging(_ panView: UIView)
    func panViewWillEndDragging(_ panView: UIView, withVelocity velocity: CGPoint, targetContentOffset: CGPoint)
}
class PanContainerView: UIView {
    var targetPoints: [CGPoint] = []
    var panView: PanScrollView = PanScrollView()
    var panBehavior: WQPanBehavior?
    var animator: UIDynamicAnimator = UIDynamicAnimator()
    
    var lastPosition: CGPoint = .zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(panView)
        panView.delegate = self
        let top = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.3)
        let bottom = CGPoint(x: Screen.width * 0.5, y: Screen.height * 0.6)
        self.targetPoints.append(top)
        self.targetPoints.append(bottom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension PanContainerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 没有到达顶点无法滚动 大于0向上滚动 小于0向下滚动
        let offset = CGPoint(x: scrollView.contentOffset.x - self.lastPosition.x, y: scrollView.contentOffset.y - self.lastPosition.y)
        let position = CGPoint(x: self.panView.frame.midX, y: self.frame.minY)
        let top = self.targetPoints.first!
        let bottom = self.targetPoints.last!
        guard !(position.y >= top.y && offset.y > 0) || !(position.y <= bottom.y && offset.y < 0) else { //在底部向下以及顶部向上之后都不处理
            return
        }
        if offset.y < 0  { // 位置大于顶部向下
            
        } else { //
            
        }
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.animator.removeAllBehaviors()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let position = CGPoint(x: self.panView.frame.midX, y: self.frame.minY)
        let top = self.targetPoints.first!
        let bottom = self.targetPoints.last!
        guard !(velocity.y > 0 && position.y >= top.y) || !(velocity.y < 0 && position.y <= bottom.y)else { //顶部向上滚动的时候
            return
        }
        var panBehavior: WQPanBehavior
        if let pan = self.panBehavior {
            panBehavior = pan
            self.panBehavior = pan
        } else {
            let pan = WQPanBehavior(with: panView)
            panBehavior = pan
        }
        if velocity.y < 0 {
            panBehavior.targetPoint = bottom
        } else {
            panBehavior.targetPoint = top
        }
        
        panBehavior.velocity = velocity
        self.animator.addBehavior(panBehavior)
    }
}
extension PanContainerView: WQPanViewable {
    func panViewDidOffset(_ panView: UIView) {
//        self.
    }
    func panViewWillBeginDragging(_ panView: UIView) {
        self.animator.removeAllBehaviors()
    }
    func panViewWillEndDragging(_ panView: UIView, withVelocity velocity: CGPoint, targetContentOffset: CGPoint) {
        
    }
}
