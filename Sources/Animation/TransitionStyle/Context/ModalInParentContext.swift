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
        guard let parent = self.config.fromViewController else { return }
        let viewController = self.viewController(controller)
        UIView.performWithoutAnimation {
            parent.addChild(controller)
            viewController.view.isUserInteractionEnabled = false
            viewController.view.frame = self.config.showControllerFrame
            parent.view.addSubview(viewController.view)
            viewController.didMove(toParent: parent)
        }
        super.interactive(present: controller, statesConfig: states)
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
    public override func interactive(finish controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
        interactiveAnimator?.addCompletion({[weak self] position in
            guard let `self` = self,
                  position == .end else { return }
            if !isModal {
                let viewController = self.viewController(controller)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            } else {
                //TODO: - 待实现
            }
            self.interactiveAnimator = nil
        })
        super.interactive(finish: controller, velocity: velocity, isModal: isModal)
        self.continueAnimation(velocity)
    }
    public override func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
        interactiveAnimator?.addCompletion({[weak self] position in
            guard let `self` = self else { return }
            if !isModal {
                guard position == .start else { return }
                if self.config.isShowWithNavigationController {
                    controller.willMove(toParent: self.navgationController(controller))
                } else {
                    if let parent = self.config.fromViewController {
                        controller.willMove(toParent: parent)
                    }
                }
                debugPrint("========")
            } else { // 取消的话 重新移除
                //TODO: - 待实现
//                UIView.performWithoutAnimation {
//                    controller.willMove(toParent: nil)
//                    controller.view.removeFromSuperview()
//                    controller.removeFromParent()
//                    controller.view.isUserInteractionEnabled = true
//                }
            }
            self.interactiveAnimator = nil
        })
        super.interactive(cancel: controller, velocity: velocity, isModal: isModal)
        self.interactiveAnimator?.isReversed = true
        self.continueAnimation(velocity)
    }
}
