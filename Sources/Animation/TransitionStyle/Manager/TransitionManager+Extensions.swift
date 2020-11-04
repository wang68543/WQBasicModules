//
//  TransitionManager+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/30.
//

import Foundation

public extension TransitionManager {
//    @objc
//    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
//        guard let view = sender.view else {
//            return
//        }
//        if width == .nan {
//            width = view.frame.width //待确认
//        }
//        switch sender.state {
//        case .began:
//            sender.setTranslation(.zero, in: view)
//            if !isShow {
//                switch self.transitionStyle {
//                case .customModal:
//                     self.showViewController.dismiss(animated: true, completion: nil)
//                default:
//                    if #available(iOS 11.0, *) {
//                        let propertyContext = TransitionPropertyContext()
//                        propertyContext.animator.addAnimations { [weak self] in
//                            guard let `self` = self else { return }
//
//                            self.preprocessor.preprocessor(willTransition: self, completion: { flag in
//
//                            })
//
//                        }
//                    }
//                }
//            }
//        case .changed:
//            self.context?.transitionUpdate(0.1)
//        case .ended:
//            self.context?.transitionFinish()
//        default:
//            self.context?.transitionCancel()
//        }
//    }
    
//    func prepareAnimate() {
//        switch self.transitionStyle {
//        case .customModal:
//
//        default:
//            <#code#>
//        }
//    }
//    func handleAnimateCompletion(_ isSuccess: Bool) {
//        switch self.transitionStyle {
//        case .customModal:
//            if self
//        default:
//            break
//        }
//    }
}
//public extension TransitionManager {
//    subscript(_ state: ModalState) -> WQReferenceStates {
//        set {
//            self.states[state] = newValue
//        }
//        get {
//            return self.states[state] ?? [:]
//        }
//    }
//}
