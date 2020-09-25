//
//  ModalDefaultAnimation.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/9/22.
//

import Foundation
public class ModalDefaultAnimation: TransitionAnimationPreprocessor {
    
    public func preprocessor(duration manager: TransitionManager) -> TimeInterval {
        return 0.25
    }
    
    public func preprocessor(readyToShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?) {
        UIView.performWithoutAnimation {
            if let bindViews = manager.snapShotAttachAnimatorViews[.readyToShow] {
                bindViews.forEach { view,subViews in
                    subViews.forEach { view.addSubview($0) }
                }
            }
            states.setup(for: .readyToShow)
        }
        completion?(true)
    }
    public func preprocessor(willShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?) {
        let duration = self.preprocessor(duration: manager)
        let options: UIView.AnimationOptions = [.beginFromCurrentState, .curveEaseOut]
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            states.setup(for: .showing)
        }) { flag in
            if let bindViews = manager.snapShotAttachAnimatorViews[.readyToShow] {
                bindViews.forEach { view,subViews in
                    subViews.forEach { $0.removeFromSuperview() }
                }
            }
            completion?(flag)
        }

    }
    public func preprocessor(readyToHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?) {
        UIView.performWithoutAnimation {
            if let bindViews = manager.snapShotAttachAnimatorViews[.readyToHide] {
                bindViews.forEach { view,subViews in
                    subViews.forEach { view.addSubview($0) }
                }
            }
            states.setup(for: .readyToHide)
        }
        completion?(true)
    }
    public func preprocessor(willHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?) {
        let duration = self.preprocessor(duration: manager)
        let options: UIView.AnimationOptions = [.beginFromCurrentState, .curveEaseOut]
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            states.setup(for: .readyToHide)
        }) { flag in
            if let bindViews = manager.snapShotAttachAnimatorViews[.readyToHide] {
                bindViews.forEach { view,subViews in
                    subViews.forEach { $0.removeFromSuperview() }
                }
            }
            completion?(flag)
        }
    }
    public func preprocessor(update manager: TransitionManager, _ percentageComplete: CGFloat) {
        
    }
}
