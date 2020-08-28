//
//  TransitionInParentPreprocessor.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/24.
//

import UIKit

class TransitionInParentPreprocessor: TransitionAnimationPreprocessor {
    func preprocessor(duration manager: TransitionManager) -> TimeInterval {
        return 0.5
    }
    
    func preprocessor(prepare manager: TransitionManager) {
         
    }
    
    func preprocessor(willTransition manager: TransitionManager, completion: @escaping TransitionManager.Completion) {
         
    }
    

}
