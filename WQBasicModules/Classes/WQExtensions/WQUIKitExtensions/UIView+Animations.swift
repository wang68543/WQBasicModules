//
//  UIView+Animations.swift
//  Pods
//
//  Created by hejinyin on 2018/3/19.
//

import UIKit

///MARK: =========== 动画 ===========
public extension UIView {
   private static let basicAnimationKey = "wq.view.basic.animationKey"
   private static let transitionAnimationKey = "wq.view.transition.animationKey"
 
    /// 基础动画
    func startRepeatRotation(duration: CFTimeInterval = 2.0) {
        let keyPath = "transform.rotation"
        var isRunning = false
        if let preAnimate = layer.animation(forKey: UIView.basicAnimationKey) as? CABasicAnimation {
            if let animateKeyPath = preAnimate.keyPath, animateKeyPath == keyPath {
                isRunning = true
            } else {
                layer.removeAnimation(forKey: UIView.basicAnimationKey)
            }
        }
        if !isRunning {
            let animate = CABasicAnimation(keyPath: keyPath)
            animate.toValue = 2 * Double.pi
            animate.repeatCount = MAXFLOAT
            animate.duration = duration
            animate.isRemovedOnCompletion = false
            layer.add(animate, forKey: UIView.basicAnimationKey)
        }
       
    }
    func stopRepeatRotation() {
        layer.removeAnimation(forKey: UIView.basicAnimationKey)
    }
    
    /// 转场动画
    func addTransitionAnimate (
        timing: String = kCAMediaTimingFunctionEaseInEaseOut,
        subtype: String = kCATransitionFade,
        duration: CFTimeInterval = 0.2
        ) {
        var isRunning = false
        if let preAnimate = layer.animation(forKey: UIView.transitionAnimationKey) as? CATransition, preAnimate.subtype == subtype {
            isRunning = true
        }
        if !isRunning {
            let transtion = CATransition()
            transtion.duration = duration
            transtion.timingFunction = CAMediaTimingFunction(name: timing)
            transtion.subtype = subtype
            layer.add(transtion, forKey: UIView.transitionAnimationKey)
        }
    }
    func removeTransitionAnimate () {
        layer.removeAnimation(forKey: UIView.transitionAnimationKey)
    }
}
