//
//  TransitionAnimationPreprocessor.swift
//  Pods
//
//  Created by WQ on 2019/9/6.
//

import Foundation
public protocol TransitionAnimation: class {
    typealias Completion = (() -> Void)
    
    var completionBlock: Completion? { get set }
    var duration: TimeInterval { get set }
//    func preprocessor(duration manager: TransitionManager) -> TimeInterval
    
//    func preprocessor(readyToShow context: ModalContext, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(willShow context: ModalContext, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(readyToHide context: ModalContext, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(willHide context: ModalContext, to states: WQReferenceStates, completion: Completion?)
    
    func preprocessor(_ state: ModalState,
                      with context: ModalContext,
                      to states: WQReferenceStates,
                      completion: Completion?)
    
    func preprocessor(update manager: TransitionManager, _ percentageComplete: CGFloat)
    
//    func preprocessor(readyToShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(willShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(readyToHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(willHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
//
//    func preprocessor(update manager: TransitionManager, _ percentageComplete: CGFloat)
    
    
}
public extension TransitionAnimation {
    func preprocessor(duration manager: TransitionManager) -> TimeInterval {
        return 0.25
    }
}

public extension WQReferenceStates {
    func setup(for state: ModalState) {
        self.forEach { target, values in
            values.forEach({ $0.setup(target, state: state) })
        }
    }
}
