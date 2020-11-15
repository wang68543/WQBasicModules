//
//  TransitionAnimationPreprocessor.swift
//  Pods
//
//  Created by WQ on 2019/9/6.
//

import Foundation
public protocol ModalAnimation: class {
    typealias Completion = (() -> Void)
    ///用于存储 show 跟hide 的时候 动画完成回调
//    var animationCompletion: Completion? { get set }
//    var completionBlocks: [ModalState: Completion] { get set }
    
    var duration: TimeInterval { get set }
    /// 是否可以动画
    var areAnimationEnable: Bool { get set }
    
    func preprocessor(_ state: ModalState,
                      layoutController: WQLayoutController,
                      config: ModalConfig,
                      states: StyleConfig,
                      completion: Completion?)
//    func preprocessor(duration manager: TransitionManager) -> TimeInterval
    
//    func preprocessor(readyToShow context: ModalContext, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(willShow context: ModalContext, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(readyToHide context: ModalContext, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(willHide context: ModalContext, to states: WQReferenceStates, completion: Completion?)
    
//    func preprocessor(_ state: ModalState,
//                      manager: TransitionManager,
//                      completion: Completion?)
//    
//    func preprocessor(_ manager: TransitionManager,
//                      percentageComplete: CGFloat)
    
//    func preprocessor(readyToShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(willShow manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(readyToHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
//    func preprocessor(willHide manager: TransitionManager, to states: WQReferenceStates, completion: Completion?)
//
//    func preprocessor(update manager: TransitionManager, _ percentageComplete: CGFloat)
    
    
}
public extension ModalAnimation {
    func preprocessor(duration manager: TransitionManager) -> TimeInterval {
        return 0.25
    }
}

