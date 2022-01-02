//
//  OneFingerRotationGestureRecognizer.swift
//  WQBasicModules
//
//  Created by WQ on 2020/10/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//
// 单指旋转手势

import UIKit

open class OneFingerRotationGestureRecognizer: UIGestureRecognizer {
    open var rotation: CGFloat = 0.0 // rotation in radians

    // velocity of the pinch in radians/second
    open var velocity: CGFloat = 0.0

    /// 用于计算速度
    private var previousTouchTimestamp: TimeInterval = .zero

    // isEnable false的时候 不会调用touch

    private var shouldRecongnizeGesture: Bool = true

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard touches.count == 1 else {
            self.shouldRecongnizeGesture = false
            return
        }
        if self.delegate?.gestureRecognizerShouldBegin?(self) == false {
            self.shouldRecongnizeGesture = false
            return
        }
        self.shouldRecongnizeGesture = true
        previousTouchTimestamp = touches.first?.timestamp ?? Date().timeIntervalSince1970
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard self.shouldRecongnizeGesture else { return }
        self.computeChanged(touches, with: event)
        if state == .possible {
            state = .began
        } else {
            state = .changed
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        guard self.shouldRecongnizeGesture else { return }
        self.computeChanged(touches, with: event)
        if state == .changed {
            state = .ended
        } else {
            state = .failed
        }
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        guard self.shouldRecongnizeGesture else { return }
        self.computeChanged(touches, with: event)
        if state == .began || state == .changed {
            state = .cancelled
        } else {
            state = .failed
        }
    }

    func computeChanged(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first,
              let contentView = self.view else { return }
        let center = CGPoint(x: contentView.frame.midX, y: contentView.frame.midY)
        let currentTouchPoint = touch.location(in: contentView)
        let previousTouchPoint = touch.previousLocation(in: contentView)

        let currentAngleRdians  = atan2f(Float(currentTouchPoint.y - center.y), Float(currentTouchPoint.x - center.x))

        let previousAngleRdians = atan2f(Float(previousTouchPoint.y - center.y), Float(previousTouchPoint.x - center.x))
        let angleInRadians = CGFloat(currentAngleRdians - previousAngleRdians)

        self.rotation = angleInRadians
        if previousTouchTimestamp != 0 && previousTouchTimestamp < touch.timestamp {
            self.velocity = abs(angleInRadians/CGFloat(touch.timestamp - previousTouchTimestamp))
        }
        previousTouchTimestamp = touch.timestamp
    }
}
