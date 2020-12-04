//
//  ModalInParentContext.swift
//  Pods
//
//  Created by WQ on 2020/8/21.
//

import UIKit
@available(iOS 10.0, *)
open class ModalInParentContext: ModalDrivenContext {
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        super.show(controller, statesConfig: statesConfig, completion: completion)
        guard let parent = self.config.fromViewController else {
            completion?()
            return
        }
        func completionCallback() {
            controller.didMove(toParent: parent)
            completion?()
        }
        parent.addChild(controller)
        parent.view.addSubview(controller.view)
        self.animator.preprocessor(.show, layoutController: controller, states: statesConfig) {
            completionCallback()
        }
    } 
    
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        super.hide(controller, animated: flag, completion: completion)
        func completionCallback() {
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            completion?()
        }
        controller.willMove(toParent: nil)
        self.animator.preprocessor(.hide, layoutController: controller, states: self.styleConfig) {
            completionCallback()
        }
         return true
    }
}
