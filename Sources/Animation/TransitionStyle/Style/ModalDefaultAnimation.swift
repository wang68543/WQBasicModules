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
        if state == .show {
            let areAnimationsEnabled =  UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            states.states[.willShow]?.setup(for: .willShow)
            UIView.setAnimationsEnabled(areAnimationsEnabled)
            if states.states[.didShow] != nil {
                UIView.animateKeyframes(withDuration: self.duration, delay: 0, options: [.beginFromCurrentState, .layoutSubviews]) {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: self.duration*0.5) {
                        states.states[.show]?.setup(for: .show)
                    }
                    UIView.addKeyframe(withRelativeStartTime: self.duration*0.5, relativeDuration: self.duration*0.5) {
                        states.states[.didShow]?.setup(for: .didShow)
                    }
                } completion: { flag in
                    completion?()
                }

            } else {
                UIView.animate(withDuration: self.duration, delay: 0, options: [.beginFromCurrentState, .layoutSubviews]) {
                    states.states[.show]?.setup(for: .show)
                } completion: { flag in
                    completion?()
                }
            }
        } else {//隐藏
            let areAnimationsEnabled =  UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            if let bindViews = states.snapShotAttachAnimatorViews[.willHide] {
                bindViews.forEach { view,subViews in
                    subViews.forEach { view.addSubview($0) }
                }
            }
            states.states[.willHide]?.setup(for: .willHide)
            UIView.setAnimationsEnabled(areAnimationsEnabled)
            
            UIView.animate(withDuration: self.duration, delay: 0, options: [.beginFromCurrentState, .layoutSubviews]) {
                states.states[.hide]?.setup(for: .hide)
            } completion: { flag in
                completion?()
            }
        }
    }
}

