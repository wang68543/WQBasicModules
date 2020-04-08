//
//  TransitionAnimationPreprocessor.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/6.
//

import Foundation
public protocol TransitionAnimationPreprocessor {
    func preprocessor(duration manager: TransitionManager) -> TimeInterval
    
    func preprocessor(prepare manager: TransitionManager)
    
    /// from to 始终是相对于
    func preprocessor(willTransition manager: TransitionManager, completion: @escaping TransitionManager.Completion)
    
    //    func transitionManager(willHide manager: TransitionManager, completion: TransitionManager.Completion )
    
    /// 手势交互弹出
//    func preprocessor(shouldShowController manager: TransitionManager) -> UIViewController
}
