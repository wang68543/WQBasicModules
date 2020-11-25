//
//  ModalInParentContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit

open class ModalInParentContext: ModalDrivenContext {
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        guard let parent = self.config.fromViewController else {
            completion?()
            return
        }
        
        func completionCallback() {
            controller.didMove(toParent: parent)
            completion?()
//            statesConfig.states.removeAll(keys: [.willShow, .show, .didShow])
        }
        parent.addChild(controller )
        parent.view.addSubview(controller.view)
        self.animator.preprocessor(.show, layoutController: controller, states: statesConfig) {
            completionCallback()
        }
    } 
    
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        func completionCallback() {
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            completion?()
//            self.styleConfig.states.removeAll(keys: [.willHide, .hide])
        }
        controller.willMove(toParent: nil)
        self.animator.preprocessor(.hide, layoutController: controller, states: self.styleConfig) {
            completionCallback()
        }
         return true
    }
}
