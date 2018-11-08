//
//  UIView+Animations.swift
//  Pods
//
//  Created by hejinyin on 2018/3/19.
//

import UIKit

///MARK: =========== 动画 ===========
public extension UIView {
    struct AnimationKey {
        static let basic = "wq.view.basic.animationKey"
        static let transition = "wq.view.transition.animationKey"
    }
//   private static let basicAnimationKey = "wq.view.basic.animationKey"
//   private static let transitionAnimationKey = "wq.view.transition.animationKey"
    /// 基础动画
    func startRepeatRotation(duration: CFTimeInterval = 2.0) {
        let keyPath = "transform.rotation"
        var isRunning = false
        if let preAnimate = layer.animation(forKey: AnimationKey.basic) as? CABasicAnimation {
            if let animateKeyPath = preAnimate.keyPath, animateKeyPath == keyPath {
                isRunning = true
            } else {
                layer.removeAnimation(forKey: AnimationKey.basic)
            }
        }
        if !isRunning {
            let animate = CABasicAnimation(keyPath: keyPath)
            animate.toValue = 2 * Double.pi
            animate.repeatCount = MAXFLOAT
            animate.duration = duration
            animate.isRemovedOnCompletion = false
            layer.add(animate, forKey: AnimationKey.basic)
        }
       
    }
    func stopRepeatRotation() {
        layer.removeAnimation(forKey: AnimationKey.basic)
    }
    
    /// 转场动画
    func addTransitionAnimate (
        timing: CAMediaTimingFunction =  CAMediaTimingFunction(name: .easeInEaseOut),
        type: CATransitionType = .fade,
        duration: CFTimeInterval = 0.2
        ) {
        var isRunning = false
        if let preAnimate = layer.animation(forKey: AnimationKey.transition) as? CATransition, preAnimate.type == type {
            isRunning = true
        }
        if !isRunning {
            let transtion = CATransition()
            transtion.duration = duration
            transtion.timingFunction = timing
            transtion.type = type
            layer.add(transtion, forKey: AnimationKey.transition)
        }
    }
    func removeTransitionAnimate () {
        layer.removeAnimation(forKey: AnimationKey.transition)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCAMediaTimingFunctionName(_ input: CAMediaTimingFunctionName) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromOptionalCATransitionSubtype(_ input: CATransitionSubtype?) -> String? {
	guard let input = input else { return nil }
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAMediaTimingFunctionName(_ input: String) -> CAMediaTimingFunctionName {
	return CAMediaTimingFunctionName(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalCATransitionSubtype(_ input: String?) -> CATransitionSubtype? {
	guard let input = input else { return nil }
	return CATransitionSubtype(rawValue: input)
}
