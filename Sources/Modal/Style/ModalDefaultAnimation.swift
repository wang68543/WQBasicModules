//
//  ModalDefaultAnimation.swift
//  Pods
//
//  Created by WQ on 2020/9/22.
//

import Foundation
@available(iOS 10.0, *)
public class ModalDefaultAnimation: ModalAnimation {
 
    
    public var animationEnable: Bool = true

    /// .zero 取context 里面默认的
    public var duration: TimeInterval = .zero
    
    public var isInteractive: Bool = false
    
    /// 这里只会调过来 两种ModalState
    public func preprocessor(_ state: ModalState, layoutController: WQLayoutController, states: StyleConfig, completion: ModalDefaultAnimation.Completion?) {
        let time = self.duration 
        func layoutIfNeeded() {
            layoutController.container.layoutIfNeeded()
            layoutController.view.layoutIfNeeded() 
            layoutController.view.updateConstraintsIfNeeded()
            layoutController.container.updateConstraintsIfNeeded()
        }
        //无动画状态更新
        func prepareStatesWithoutAnimation(_ modalState: ModalState) {
            let areAnimationsEnabled =  UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            if let views = states.snapShotAttachAnimatorViews[modalState] {
                views.forEach { view, subViews in
                    subViews.forEach { view.addSubview($0) }
                }
            }
            states.states.setup(forState: modalState)
            layoutIfNeeded()
            UIView.setAnimationsEnabled(areAnimationsEnabled)
        }
        //以默认的动画更新
        func updateWithDefaultAnimation(_ modalState: ModalState) {
            UIView.animate(withDuration: time, delay: 0, options: [.beginFromCurrentState, .layoutSubviews, .curveEaseOut]) {
                states.states.setup(forState: modalState)
                layoutIfNeeded()
            } completion: { flag in
                // 移除动画的View
                UIView.performWithoutAnimation {
                    if let preState = modalState.preNode,
                       let views = states.snapShotAttachAnimatorViews[preState] {
                        views.forEach { view, subViews in
                            subViews.forEach { $0.removeFromSuperview() }
                        }
                    }
                }
                completion?()
            }
        }
        
        if state == .show {
            if !self.animationEnable { //不动画
                UIView.performWithoutAnimation {
                    if states.states.has(key: .didShow) {
                        states.states.setup(forState: .didShow)
                    } else {
                        states.states.setup(forState: .show)
                    }
                    layoutIfNeeded()
                }
                completion?()
            } else {
                prepareStatesWithoutAnimation(.willShow)
                if self.isInteractive { // 交互显示(拖拽)
                    if states.states.has(key: .didShow) {
                        updateWithDefaultAnimation(.didShow)
                    } else {
                        updateWithDefaultAnimation(.show)
                    }
                } else {
                    if states.states.has(key: .didShow) {
                        let keys: [ModalState] = [.show, .didShow]
                        UIView.animateKeyframes(withDuration: time, delay: 0, options: .calculationModeLinear) {
                            let unit = time/TimeInterval(keys.count)
                            for index in 0..<keys.count {
                                let keyFrame = keys[index]
                                UIView.addKeyframe(withRelativeStartTime: unit*TimeInterval(index), relativeDuration: unit) {
                                    states.states.setup(forState: keyFrame)
                                    layoutIfNeeded()
                                }
                            }
                        } completion: { flag in
                            completion?()
                        }
                    } else {
                        updateWithDefaultAnimation(.show)
                    }
                }
            }
        } else {//隐藏
            if !self.animationEnable {
                UIView.performWithoutAnimation {
                    states.states.setup(forState: .hide)
                    layoutIfNeeded()
                }
                completion?()
            } else {
                prepareStatesWithoutAnimation(.willHide)
                /// 更新隐藏
                updateWithDefaultAnimation(.hide)
            }
            
        }
    }
}

