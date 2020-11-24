//
//  ModalDefaultAnimation.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/9/22.
//

import Foundation 
public class ModalDefaultAnimation: ModalAnimation {
 
    
    public var areAnimationEnable: Bool = true

    public var duration: TimeInterval = 0.45
    
    public func preprocessor(_ state: ModalState, layoutController: WQLayoutController, config: ModalConfig, states: StyleConfig, completion: ModalDefaultAnimation.Completion?) {
        let time = self.duration
        let areAnimationsEnabled =  UIView.areAnimationsEnabled
        UIView.setAnimationsEnabled(false)
        if state == .show {
            states.states[.willShow]?.setup(for: .willShow)
            layoutController.container.setNeedsLayout()
            layoutController.view.setNeedsLayout()
            UIView.setAnimationsEnabled(areAnimationsEnabled)
            
            if states.states.has(key: .didShow) {
                let keys: [ModalState] = [.show, .didShow]
                UIView.animateKeyframes(withDuration: time, delay: 0, options: .calculationModeLinear) {
                    let unit = time/TimeInterval(keys.count)
                    for index in 0..<keys.count {
                        let keyFrame = keys[index]
                        UIView.addKeyframe(withRelativeStartTime: unit*TimeInterval(index), relativeDuration: unit) {
                            states.states[keyFrame]?.setup(for: keyFrame)
                        }
                    }
                } completion: { flag in
                    completion?()
                }

            } else {
                UIView.animate(withDuration: time, delay: 0, options: [.beginFromCurrentState, .layoutSubviews]) {
                    states.states[.show]?.setup(for: .show)
                } completion: { flag in
                    completion?()
                }
            }
        } else {//隐藏
            if let bindViews = states.snapShotAttachAnimatorViews[.willHide] {
                bindViews.forEach { view,subViews in
                    subViews.forEach { view.addSubview($0) }
                }
            }
            if states.states.has(key: .willHide) {
                states.states[.willHide]?.setup(for: .willHide)
                layoutController.container.setNeedsLayout()
                layoutController.view.setNeedsLayout()
            }
            UIView.setAnimationsEnabled(areAnimationsEnabled)
            
            UIView.animate(withDuration: time, delay: 0, options: [.beginFromCurrentState, .layoutSubviews]) {
                states.states[.hide]?.setup(for: .hide)
            } completion: { flag in
                completion?()
            }
        }
    }
}

