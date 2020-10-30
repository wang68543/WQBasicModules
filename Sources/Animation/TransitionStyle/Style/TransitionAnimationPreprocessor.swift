//
//  TransitionAnimationPreprocessor.swift
//  Pods
//
//  Created by WQ on 2019/9/6.
//

import Foundation
public protocol TransitionAnimationPreprocessor: class {
    typealias Completion = ((Bool) -> Void)
    
    func preprocessor(duration manager: TransitionManager) -> TimeInterval
    
    func preprocessor(readyToShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
    func preprocessor(willShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
    func preprocessor(readyToHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
    func preprocessor(willHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
    
    func preprocessor(update manager: TransitionManager, _ percentageComplete: CGFloat)
    
}
public extension TransitionAnimationPreprocessor {
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
