//
//  TransitionAnimationPreprocessor.swift
//  Pods
//
//  Created by WQ on 2019/9/6.
//

import Foundation
public protocol TransitionAnimationPreprocessor { 
    func preprocessor(duration manager: TransitionManager) -> TimeInterval
    
    func preprocessor(prepare manager: TransitionManager, readyToShow states: [TSReferenceWriteable])
    
    /// from to 始终是相对于
    func preprocessor(willShow manager: TransitionManager, to states:[TSReferenceWriteable], completion: @escaping TransitionManager.Completion)
    
    func preprocessor(willHide manager: TransitionManager, to states:[TSReferenceWriteable], completion: @escaping TransitionManager.Completion)
    
    func preprocessor(update manager: TransitionManager, _ percentageComplete: CGFloat)
    
}
