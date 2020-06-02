//
//  TransitionDefaultPreprocessor.swift
//  Pods
//
//  Created by WQ on 2019/9/6.
//

import Foundation
public class TransitionDefaultPreprocessor: TransitionAnimationPreprocessor {
    public func preprocessor(prepare manager: TransitionManager) {
        
    }
    
    public func preprocessor(willTransition manager: TransitionManager, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.25, animations: {
            
        }) { flag in
            completion(flag)
        }
    }
    
    public func preprocessor(duration manager: TransitionManager) -> TimeInterval {
        return 0.25
    }
    
//    public func preprocessor(shouldShowController manager: TransitionManager) -> UIViewController {
//
//    }
    
}
