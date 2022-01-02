//
//  CALayer+Animations.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/11/4.
//

import UIKit
@available(iOSApplicationExtension, unavailable)
public extension CALayer {
    struct AnimationKeys {
        static let rotation = "wq.layer.anmations.rotation"
        static let transition = "wq.layer.anmations.transition"
        // If `bitPattern` is zero, the result is `nil`.
        static let isAnimating = UnsafeRawPointer(bitPattern: "wq.layer.anmations.isAnimating".hashValue)!
    }

    private(set) var isAnimating: Bool {
        set {
            objc_setAssociatedObject(self, AnimationKeys.isAnimating, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
             (objc_getAssociatedObject(self, AnimationKeys.isAnimating) as? Bool) ?? false
        }
    }

    @discardableResult
    func rotation(_ from: Double = 0,
                  to angle: Double = Double.pi * 2,
                  duration: Double,
                  isRepeat: Bool) -> CABasicAnimation {
        let keyPath = "transform.rotation"
        let animate = CABasicAnimation(keyPath: keyPath)
        animate.fromValue = Double(0)
        animate.toValue = angle
        animate.repeatCount = isRepeat ? MAXFLOAT : 1
        animate.duration = duration
        animate.isRemovedOnCompletion = false
        self._add(animate, forKey: AnimationKeys.rotation)
        return animate
    }

    func stopRotation() {
        self._remove(forKey: AnimationKeys.rotation)
    }

    @discardableResult
    func transition(timing: CAMediaTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut),
                    type: CATransitionType = .fade,
                    duration: CFTimeInterval = 0.2) -> CATransition {
        let transtion = CATransition()
        transtion.duration = duration
        transtion.timingFunction = timing
        transtion.type = type
        self._add(transtion, forKey: AnimationKeys.transition)
        return transtion
    }

    func stopTransition() {
        self._remove(forKey: AnimationKeys.transition)
    }

    private func _add(_ animate: CAAnimation, forKey key: String) {
        if self.animation(forKey: key) != nil {
           self.removeAnimation(forKey: key)
        }
        animate.delegate = self
        self.add(animate, forKey: key)
    }
    private func _remove(forKey key: String) {
        self.removeAnimation(forKey: key)
    }
}

extension CALayer: CAAnimationDelegate {
    public func animationDidStart(_ anim: CAAnimation) {
        self.isAnimating = true
    }
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isAnimating = false
    }
}
