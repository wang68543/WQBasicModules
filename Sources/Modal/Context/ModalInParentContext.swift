//
//  ModalInParentContext.swift
//  Pods
//
//  Created by WQ on 2020/8/21.
//

import UIKit
@available(iOS 10.0, *)
open class ModalInParentContext:  ModalDrivenContext { 
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        let viewController = self.viewController(controller)
        guard !viewController.isMovingToParent else { return }
        super.show(controller, statesConfig: statesConfig, completion: completion)
        guard let parent = self.config.fromViewController else {
            completion?()
            return
        }
        func completionCallback() {
            viewController.didMove(toParent: parent)
            completion?()
        }
        parent.addChild(viewController)
        viewController.view.frame = self.config.showControllerFrame
        parent.view.addSubview(viewController.view)
        self.animator.preprocessor(.show, layoutController: controller, states: statesConfig) {
            completionCallback()
        }
    }
    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        let viewController = self.viewController(controller)
        guard !viewController.isMovingToParent else { return }
        super.interactive(present: controller, statesConfig: states)
        guard let parent = self.config.fromViewController else { return }
 
        UIView.performWithoutAnimation {
            parent.addChild(viewController)
            viewController.view.frame = self.config.showControllerFrame
            parent.view.addSubview(viewController.view)
            states.states.setup(forState: .willShow) 
        }
        super.interactive(present: controller, statesConfig: states)
        interactiveAnimator = UIViewPropertyAnimator(duration: self.animator.duration, curve: .easeOut, animations: { [weak self] in
            guard let `self` = self else { return }
            if self.styleConfig.states.has(key: .didShow) {
                self.styleConfig.states.setup(forState: .didShow)
            } else {
                self.styleConfig.states.setup(forState: .show)
            }
        })
    }

    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        let handleDismiss = true
        let viewController = self.viewController(controller)
        guard !viewController.isMovingFromParent else { return handleDismiss }
        super.hide(controller, animated: flag, completion: completion)
        func completionCallback() {
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
            completion?()
        }
        viewController.willMove(toParent: nil)
        self.animator.preprocessor(.hide, layoutController: controller, states: self.styleConfig) {
            completionCallback()
        }
         return handleDismiss
    }
    public override func interactive(dismiss controller: WQLayoutController) {
        let viewController = self.viewController(controller)
        guard !viewController.isMovingFromParent else { return }
        if interactiveAnimator?.isRunning == true {
            interactiveAnimator?.stopAnimation(true)
        }
        super.interactive(dismiss: controller)
        viewController.willMove(toParent: nil)
        interactiveAnimator = UIViewPropertyAnimator(duration: self.animator.duration, curve: .easeOut, animations: { [weak self] in
            guard let `self` = self else { return }
            self.styleConfig.states.setup(forState: .hide)
        })
    }
    public override func interactive(finish velocity: CGPoint) {
        interactiveAnimator?.addCompletion({[weak self] position in
            guard let `self` = self,
                  position == .end else { return }
            if !self.isShow {
                if let viewController = self.interactViewController {
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                }
            } else {
                if let parent = self.config.fromViewController,
                   let viewController = self.interactViewController {
                    viewController.didMove(toParent: parent)
                }
            }
            self.interactiveAnimator = nil
        })
        super.interactive(finish: velocity)
        self.continueAnimation(velocity)
        
    }
    public override func interactive(cancel velocity: CGPoint) {
        interactiveAnimator?.addCompletion({[weak self] position in
            guard let `self` = self else { return }
            if !self.isShow {
                guard position == .start else { return }
                if let parent = self.config.fromViewController,
                   let controller = self.interactViewController {
                    controller.willMove(toParent: parent)
                } 
            } else { // 取消的话 重新移除
                if let viewController = self.interactViewController {
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                }
            }
            self.interactiveAnimator = nil
        })
        super.interactive(cancel: velocity)
        self.interactiveAnimator?.isReversed = true
        self.continueAnimation(velocity)
    }
}
