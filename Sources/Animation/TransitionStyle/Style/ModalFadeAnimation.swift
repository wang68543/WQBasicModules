//
//  ModalFadeAnimation.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/11/5.
//

import Foundation
public class ModalFadeAnimation: ModalDefaultAnimation {
    
    public override func preprocessor(_ state: ModalState, layoutController: WQLayoutController, config: ModalConfig, states: StyleConfig, completion: ModalDefaultAnimation.Completion?) {
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
  
//    func willShow(_ layoutController: WQLayoutController, config: ModalConfig, states: StyleConfig, completion: ModalDefaultAnimation.Completion?) {
//        let areAnimationsEnabled =  UIView.areAnimationsEnabled
//        UIView.setAnimationsEnabled(false)
//        switch states.showStyle {
//        case .alert:
//            layoutController.dimmingView.alpha = 0.0
//            layoutController.container.alpha = 0.0
//            let controllerSize = states.showControllerFrame.size
//            let size = layoutController.container.sizeThatFits()
////            layoutController.container.center = CGPoint(x: controllerSize.width*0.5, y: controllerSize.height*0.5)
//            
//            layoutController.container.frame = CGRect(x: (controllerSize.width - size.width)*0.5, y: (controllerSize.height - size.height)*0.5, width: size.width, height: size.height)
//            layoutController.container.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//        case .actionSheet:
//            layoutController.dimmingView.alpha = 0.0
//            let size = layoutController.container.sizeThatFits()
//            let controllerSize = states.showControllerFrame.size
//            layoutController.container.center = CGPoint(x: controllerSize.width*0.5, y: controllerSize.height - layoutController.container.bounds.height*0.5)
//            layoutController.container.transform = CGAffineTransform(translationX: 0, y: layoutController.container.modalSize.height)
//        case .custom:
//            if let bindViews = states.snapShotAttachAnimatorViews[.willShow] {
//                bindViews.forEach { view,subViews in
//                    subViews.forEach { view.addSubview($0) }
//                }
//            }
//            states.states[.willShow]?.setup(for: .willShow)
//        default:
//            break
//        }
//        layoutController.view.setNeedsLayout()
//        UIView.setAnimationsEnabled(areAnimationsEnabled)
//        completion?()
//    }
//    
//    func show(_ layoutController: WQLayoutController, config: ModalConfig, states: StyleConfig, completion: ModalDefaultAnimation.Completion?) {
//        UIView.animate(withDuration: self.duration - 0.2, delay: 0, options: [.beginFromCurrentState, .layoutSubviews]) {
//            switch states.showStyle {
//            case .alert:
//                layoutController.dimmingView.alpha = 1.0
//                layoutController.container.alpha = 1.0
////                layoutController.container.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//            case .actionSheet:
//                layoutController.container.alpha = 1.0
//                layoutController.dimmingView.alpha = 1.0
//                layoutController.container.transform = CGAffineTransform(translationX: 0, y: -10)
//            case .custom:
//                states.states[.show]?.setup(for: .show)
//            default :
//                break
//            }
//        } completion: { flag in
//            switch states.showStyle {
//            case .alert, .actionSheet:
//                UIView.animate(withDuration: 0.2) {
//                    layoutController.container.transform = .identity
//                } completion: { flag in
//                    completion?()
//                }
//            default:
//                if let bindViews = states.snapShotAttachAnimatorViews[.willShow] {
//                   bindViews.forEach { view,subViews in
//                       subViews.forEach { $0.removeFromSuperview() }
//                   }
//                }
//                completion?()
//            }
//        }
//    }
//    
//    func willHide(_ layoutController: WQLayoutController, config: ModalConfig, states: StyleConfig, completion: ModalDefaultAnimation.Completion?) {
//        let areAnimationsEnabled =  UIView.areAnimationsEnabled
//        UIView.setAnimationsEnabled(false)
//        switch states.showStyle {
//        case .alert:
//            break
//        case .actionSheet:
//            break
//        case .custom:
//            if let bindViews = states.snapShotAttachAnimatorViews[.willHide] {
//                bindViews.forEach { view,subViews in
//                    subViews.forEach { view.addSubview($0) }
//                }
//            }
//            states.states[.willHide]?.setup(for: .willHide)
//        default:
//            break
//        }
//        UIView.setAnimationsEnabled(areAnimationsEnabled)
//        completion?()
//    }
//    
//    func hide(_ layoutController: WQLayoutController, config: ModalConfig, states: StyleConfig, completion: ModalDefaultAnimation.Completion?) {
//        UIView.animate(withDuration: self.duration, delay: 0, options: [.beginFromCurrentState, .layoutSubviews]) {
//            switch states.showStyle {
//            case .alert:
//                layoutController.container.alpha = 0.0
//                layoutController.container.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            case .actionSheet:
//                layoutController.container.transform = CGAffineTransform(translationX: 0, y: layoutController.container.modalSize.height)
//            default:
//                states.states[.hide]?.setup(for: .hide)
//            }
//        } completion: { flag in
//            completion?()
//        }
//    }
}
