//
//  ModalDefaultAnimation.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/9/22.
//

import Foundation 
public class ModalDefaultAnimation: TransitionAnimation {
    public func preprocessor(_ state: ModalState, layoutController: WQLayoutController, config: ModalConfig, states: StyleConfig, completion: Completion?) {
         
    }
    
    public var areAnimationEnable: Bool = true
    
    public var completionBlock: Completion?
    
//    public var completionBlocks: [ModalState: Completion] = [:]

    public var duration: TimeInterval = 0.45
    
//    public func preprocessor(_ manager: TransitionManager, state: ModalState, completion: Completion?) {
//         
//    } 
    
    
//    public func preprocessor(_ state: ModalState, with context: ModalContext, to states: WQReferenceStates, completion: Completion?) {
//
//    }
//
//    public func preprocessor(duration manager: TransitionManager) -> TimeInterval {
//        return 0.25
//    }
//
//    public func preprocessor(readyToShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?) {
//        UIView.performWithoutAnimation {
//            if let bindViews = manager.snapShotAttachAnimatorViews[.readyToShow] {
//                bindViews.forEach { view,subViews in
//                    subViews.forEach { view.addSubview($0) }
//                }
//            }
//            states.setup(for: .readyToShow)
//        }
//        completion?()
//    }
//    public func preprocessor(willShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?) {
//        let duration = self.preprocessor(duration: manager)
//        let options: UIView.AnimationOptions = [.beginFromCurrentState, .curveEaseOut]
//        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
//            states.setup(for: .showing)
//        }) { flag in
//            if let bindViews = manager.snapShotAttachAnimatorViews[.readyToShow] {
//                bindViews.forEach { view,subViews in
//                    subViews.forEach { $0.removeFromSuperview() }
//                }
//            }
//            completion?()
//        }
//
//    }
//    public func preprocessor(readyToHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?) {
//        UIView.performWithoutAnimation {
//            if let bindViews = manager.snapShotAttachAnimatorViews[.readyToHide] {
//                bindViews.forEach { view,subViews in
//                    subViews.forEach { view.addSubview($0) }
//                }
//            }
//            states.setup(for: .readyToHide)
//        }
//        completion?()
//    }
//    public func preprocessor(willHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?) {
//        let duration = self.preprocessor(duration: manager)
//        let options: UIView.AnimationOptions = [.beginFromCurrentState, .curveEaseOut]
//        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
//            states.setup(for: .readyToHide)
//        }) { flag in
//            if let bindViews = manager.snapShotAttachAnimatorViews[.readyToHide] {
//                bindViews.forEach { view,subViews in
//                    subViews.forEach { $0.removeFromSuperview() }
//                }
//            }
//            completion?()
//        }
//    }
    
    public func preprocessor(update manager: TransitionManager, _ percentageComplete: CGFloat) {
        
    }
}

