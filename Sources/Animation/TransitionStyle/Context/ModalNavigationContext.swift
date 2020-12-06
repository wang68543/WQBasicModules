//
//  ModalPresentWithNavRootContext.swift
//  Pods
//
//  Created by WQ on 2020/9/3.
//

import UIKit
@available(iOS 10.0, *)
public class ModalNavigationContext: ModalContext {
    private var interactController: UIPercentDrivenInteractiveTransition?
    
    var currentNavigationController: UINavigationController? {
        if let nav = self.config.style.fromViewController as? UINavigationController {
            return nav
        } else {
            return WQUIHelp.topNavigationController()
        }
    }
    private var previousDelegate: UINavigationControllerDelegate?
    /// 存储的保存的view
    private var snapshotView: UIView?
    
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        guard let nav = currentNavigationController else { return }
        guard !controller.isPushing else { return }
        controller.isPushing = true
        let flag = self.animator.areAnimationEnable
        super.show(controller, statesConfig: statesConfig, completion: completion)
        previousDelegate = nav.delegate
        nav.delegate = self
        let viewController = self.viewController(controller)
        nav.pushViewController(viewController, animated: flag)
    }
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        guard let nav = currentNavigationController else { return true }
        guard !controller.isPoping else { return true }
        controller.isPoping = true
        let flag = self.animator.areAnimationEnable
        super.hide(controller, animated: flag, completion: completion)
        let viewController = self.viewController(controller)
        if nav.topViewController === viewController {
            self.previousDelegate = nav.delegate
            nav.delegate = self
            nav.popViewController(animated: flag)
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            nav.popViewController(animated: flag)
            CATransaction.commit()
        }
        return true
    }

    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        guard !controller.isBeingPresented else { return }
        super.interactive(present: controller, statesConfig: states)
        controller.navigationController?.delegate = self
        controller.view.isUserInteractionEnabled = false
        interactController = UIPercentDrivenInteractiveTransition()
        self.config.fromViewController?.present(controller, animated: true, completion: nil)
    }

    public override func interactive(dismiss controller: WQLayoutController) {
        guard let nav = currentNavigationController else { return }
        let viewController = self.viewController(controller)
        guard !controller.isPoping else { return }
        controller.isPoping = true
        super.interactive(dismiss: controller)
        let flag = self.animator.areAnimationEnable
        if nav.topViewController === viewController {
            self.previousDelegate = nav.delegate
            nav.delegate = self
            interactController = UIPercentDrivenInteractiveTransition()
        }
        nav.popViewController(animated: flag)
    }
    public override func interactive(update controller: WQLayoutController, progress: CGFloat, isModal: Bool) {
        super.interactive(update: controller, progress: progress, isModal: isModal)
        self.interactController?.update(progress)
    }
    public override func interactive(finish controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
        super.interactive(finish: controller, velocity: velocity, isModal: isModal)
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactController?.timingCurve = provider
        self.interactController?.finish()
        if isModal {
            controller.view.isUserInteractionEnabled = true
        }
    //        self.intercatController = nil
    }
    public override func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
        super.interactive(cancel: controller, velocity: velocity, isModal: isModal)
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactController?.timingCurve = provider
        self.interactController?.cancel()
    //        self.intercatController = nil
    }

}
@available(iOS 10.0, *)
extension ModalNavigationContext: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactController : nil
    }
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 这里 afterScreenUpdates 为true的时候就不会走自定义的动画
        if self.isModal {
            if let view = navigationController.view.snapshotView(afterScreenUpdates: false) {
                snapshotView = view
            }
        } else {
            snapshotView?.removeFromSuperview()
        }
//        else {
//            if fromVC is UINavigationController {
//                if let view = fromVC.view.snapshotView(afterScreenUpdates: false) {
//                    snapshotView = view
//                }
//            } else if let view = fromVC.navigationController?.view.snapshotView(afterScreenUpdates: false) {
//                snapshotView = view
//            }
//        }
        
        return self
    }
}
@available(iOS 10.0, *)
extension ModalNavigationContext: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if !self.animator.areAnimationEnable {
            return 0.01
        }
        return self.animator.duration
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        let vcFinalFrame = transitionContext.finalFrame(for: toVC)
        let isPresented = self.isModal
        func completionBlock() {
            let success = !transitionContext.transitionWasCancelled
            if (isPresented && !success) {
                toVC.view.removeFromSuperview()
            }
            if self.isModal {
                if self.config.isShowWithNavigationController,
                   let nav = toVC as? UINavigationController,
                   let showViewController = nav.topViewController as? WQLayoutController {
                    showViewController.isPushing = false
                } else if let showViewController = toVC as? WQLayoutController {
                    showViewController.isPushing = false
                }
            } else {
                if self.config.isShowWithNavigationController,
                   let nav = fromVC as? UINavigationController,
                   let showViewController = nav.topViewController as? WQLayoutController {
                    showViewController.isPoping = false
                } else if let showViewController = fromVC as? WQLayoutController {
                    showViewController.isPoping = false
                }
            }
            currentNavigationController?.delegate = previousDelegate
            previousDelegate = nil
//            snapshotView?.removeFromSuperview()
//            snapshotView = nil
            transitionContext.completeTransition(success)
            
        }
        let toVCView = transitionContext.view(forKey: .to)
        let transitionView = transitionContext.containerView
        
        if let snapshot = self.snapshotView {
            transitionView.addSubview(snapshot)
        }
        
        if let toView = toVCView {
            if transitionView !== toView {//解决 多次动画 而把自己放在栈顶的问题
               transitionView.addSubview(toView)
            }
        }
        
        if isPresented {
            toVCView?.frame = vcFinalFrame
            if self.config.isShowWithNavigationController,
               let nav = toVC as? UINavigationController,
               let showViewController = nav.topViewController as? WQLayoutController {
                self.animator.preprocessor(.show, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else if let showViewController = toVC as? WQLayoutController {
                self.animator.preprocessor(.show, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            }
        } else {
            if self.config.isShowWithNavigationController,
               let nav = fromVC as? UINavigationController,
               let showViewController = nav.topViewController as? WQLayoutController {
                self.animator.preprocessor(.hide, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else if let showViewController = fromVC as? WQLayoutController {
                self.animator.preprocessor(.hide, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            }
        }
        
    }
}

//public class ModalNavigationContext: ModalContext {
//    weak var navigationController: UINavigationController?
//
//    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
//        guard let navigationController = controller.navigationController,
//              !navigationController.isMovingToParent else {
//            completion?()
//            return
//        }
//        #if targetEnvironment(macCatalyst)
//        let view = UIApplication.shared.windows.last
//        #else
//        let view = UIApplication.shared.keyWindow
//        #endif
//        if let snapshot = view?.snapshotView(afterScreenUpdates: true) {
//            UIView.performWithoutAnimation {
//                navigationController.setNavigationBarHidden(true, animated: false)
//                navigationController.view.addSubview(snapshot)
//            }
//        }
//        super.show(controller, statesConfig: statesConfig, completion: completion)
//        guard let parent = self.config.fromViewController else {
//            completion?()
//            return
//        }
//        func completionCallback() {
//            navigationController.didMove(toParent: parent)
//            completion?()
//        }
//        UIView.performWithoutAnimation {
//            parent.addChild(navigationController)
//            parent.view.addSubview(navigationController.view)
//        }
//        self.animator.preprocessor(.show, layoutController: controller, states: statesConfig) {
//            completionCallback()
//        }
//    }
//    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
//        guard let navigationController = controller.navigationController,
//              !navigationController.isMovingToParent else {
//            return
//        }
//        #if targetEnvironment(macCatalyst)
//        let view = UIApplication.shared.windows.last
//        #else
//        let view = UIApplication.shared.keyWindow
//        #endif
//        if let snapshot = view?.snapshotView(afterScreenUpdates: true) {
//            UIView.performWithoutAnimation {
//                navigationController.setNavigationBarHidden(true, animated: false)
//                navigationController.view.addSubview(snapshot)
//            }
//        }
//        super.interactive(present: controller, statesConfig: states)
//    }
//    public override func interactive(cancel controller: WQLayoutController, velocity: CGPoint, isModal: Bool) {
//        guard let navigationController = controller.navigationController,
//              !navigationController.isMovingFromParent else {
//            return
//        }
//        interactiveAnimator?.addCompletion({[weak self] position in
//            guard let `self` = self else { return }
//            if !isModal {
//                if position == .start {
//                    debugPrint("========")
//                }
//            } else { // 取消的话 重新移除
//                UIView.performWithoutAnimation {
//                    controller.willMove(toParent: nil)
//                    controller.view.removeFromSuperview()
//                    controller.removeFromParent()
//                    controller.view.isUserInteractionEnabled = true
//                }
//            }
//            self.interactiveAnimator = nil
//        })
//        super.interactive(cancel: controller, velocity: velocity, isModal: isModal)
//    }
//    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
//        guard !controller.isMovingFromParent else { return false }
//        super.hide(controller, animated: flag, completion: completion)
//        func completionCallback() {
//            controller.view.removeFromSuperview()
//            controller.removeFromParent()
//            completion?()
//        }
//        controller.willMove(toParent: nil)
//        self.animator.preprocessor(.hide, layoutController: controller, states: self.styleConfig) {
//            completionCallback()
//        }
//         return true
//    }
//}
