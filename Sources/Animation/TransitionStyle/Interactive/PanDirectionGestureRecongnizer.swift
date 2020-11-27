//
//  PanDirectionGestureRecongnizer.swift
//  Pods
//
//  Created by 王强 on 2020/11/8.
//

import UIKit

open class PanDirectionGestureRecongnizer: UIPanGestureRecognizer {
    var direction: PanDirection!
    /// 是否可以开始识别
    func canShouldBegin(_ velocity: CGPoint) -> Bool {
        return direction.isSameDirection(with: velocity)
    }
}
