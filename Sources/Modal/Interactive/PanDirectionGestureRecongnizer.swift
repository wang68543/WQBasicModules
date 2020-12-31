//
//  PanDirectionGestureRecongnizer.swift
//  Pods
//
//  Created by 王强 on 2020/11/8.
//

import UIKit

open class PanDirectionGestureRecongnizer: UIPanGestureRecognizer {
    var lockDirection: PanDirection!
    
    public var progress: CGFloat {
        let width = translationLength
        guard let gestureView = self.view,
              !width.isZero else { return .zero }
        let offset = self.translation(in: gestureView)
        let progress = lockDirection.translateOffset(with: offset)/width
        return max(0.001, min(0.999, progress))
    }
    private var translationLength: CGFloat {
        guard let gestureView = self.view else { return .zero }
        if self.lockDirection.isHorizontal {
            return gestureView.bounds.width
        } else {
            return gestureView.bounds.height
        }
    }
    /// 是否可以开始识别
    func canShouldBegin(_ velocity: CGPoint) -> Bool {
        return lockDirection.isSameDirection(with: velocity)
    }
}
