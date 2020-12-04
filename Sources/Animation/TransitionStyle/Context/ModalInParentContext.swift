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
        guard !controller.isMovingToParent else { return }
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
    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        guard let parent = self.config.fromViewController else { return }
        UIView.performWithoutAnimation {
            parent.addChild(controller)
            controller.view.isUserInteractionEnabled = false
            parent.view.addSubview(controller.view)
            controller.didMove(toParent: parent)
        }
        super.interactive(present: controller, statesConfig: states)
    }
    public override func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isDismiss: Bool) {
        interactiveAnimator?.addCompletion({[weak self] position in
            guard let `self` = self else { return }
            if isDismiss {
                if position == .start {
                    debugPrint("========")
                }
            } else { // 取消的话 重新移除
                UIView.performWithoutAnimation {
                    controller.willMove(toParent: nil)
                    controller.view.removeFromSuperview()
                    controller.removeFromParent()
                    controller.view.isUserInteractionEnabled = true
                }
            }
            self.interactiveAnimator = nil
        })
        super.interactive(cancel: controller, velocity: velocity, isDismiss: isDismiss)
    }
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        guard !controller.isMovingFromParent else { return false }
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
