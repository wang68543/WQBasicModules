//
//  TransitionAnimationPreprocessor.swift
//  Pods
//
//  Created by WQ on 2019/9/6.
//

import Foundation
public protocol ModalAnimation: class {
    typealias Completion = (() -> Void)
    
    var duration: TimeInterval { get set }
    /// 是否可以动画
    var areAnimationEnable: Bool { get set }
    
    func preprocessor(_ state: ModalState,
                      layoutController: WQLayoutController, 
                      states: StyleConfig,
                      completion: Completion?)
//
//    func preprocessor(update manager: TransitionManager, _ percentageComplete: CGFloat)
    
    
}
