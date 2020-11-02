//
//  TransitionManager+LayoutControllerDelegate.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/30.
//

import Foundation
extension TransitionManager: WQLayoutControllerDelegate {
    public func didViewLoad(_ controller: WQLayoutController) {
        
    }
    
    public func show(_ controller: WQLayoutController, animated flag: Bool, completion: WQLayoutController.Completion?) {
        
    }
    
    public func hide(_ controller: WQLayoutController, animated flag: Bool, completion: WQLayoutController.Completion?) -> Bool {
        return true
    }
    
    
}
