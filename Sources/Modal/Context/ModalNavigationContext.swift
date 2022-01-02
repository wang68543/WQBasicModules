//
//  ModalPresentWithNavRootContext.swift
//  Pods
//
//  Created by WQ on 2020/9/3.
//

import UIKit
@available(iOS 10.0, *)
public class ModalNavigationContext: ModalContext {
    private var interactAnimator: UIPercentDrivenInteractiveTransition?

    var currentNavigationController: UINavigationController? {
        if let nav = self.config.style.fromViewController as? UINavigationController {
            return nav
        } else {
            return WQUIHelp.topNavigationController()
        }
    }
    private weak var previousDelegate: UINavigationControllerDelegate?
    /// 存储的保存的view
//    private var snapshotView: UIView?

    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        guard let nav = currentNavigationController else { return }
        guard !controller.isPushing else { return }
        controller.isPushing = true
        let flag = self.animator.animationEnable
        super.show(controller, statesConfig: statesConfig, completion: completion)
        previousDelegate = nav.delegate
        nav.delegate = self
        nav.pushViewController(controller, animated: flag)
    }
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) { // -> Bool
        guard let nav = currentNavigationController else { return }
        guard !controller.isPoping else { return }
        controller.isPoping = true
        let flag = self.animator.animationEnable
        super.hide(controller, animated: flag, completion: completion)
        if nav.topViewController === controller {
            self.previousDelegate = nav.delegate
            nav.delegate = self
            nav.popViewController(animated: flag)
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                controller.isPoping = false
                completion?()
            }
            nav.popViewController(animated: flag)
            CATransaction.commit()
        }
//        return true
    }

    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        guard let nav = currentNavigationController else { return }
        guard !controller.isBeingPresented else { return }
        super.interactive(present: controller, statesConfig: states)
        previousDelegate = nav.delegate
        nav.delegate = self
        interactAnimator = UIPercentDrivenInteractiveTransition()
        nav.pushViewController(controller, animated: true)
    }

    public override func interactive(dismiss controller: WQLayoutController) {
        guard let nav = currentNavigationController else { return }
        guard !controller.isPoping else { return }
        controller.isPoping = true
        super.interactive(dismiss: controller)
        let flag = self.animator.animationEnable
        if nav.topViewController === controller {
            self.previousDelegate = nav.delegate
            nav.delegate = self
            interactAnimator = UIPercentDrivenInteractiveTransition()
        }
        nav.popViewController(animated: flag)
    }
    public override func interactive(update progress: CGFloat) {
        super.interactive(update: progress)
        self.interactAnimator?.update(progress)
    }
    public override func interactive(finish velocity: CGPoint) {
        super.interactive(finish: velocity)
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactAnimator?.timingCurve = provider
        self.interactAnimator?.finish()
//        if isShow {
//            self.interactViewController?.view.isUserInteractionEnabled = true
//        }
        self.interactAnimator = nil
    }
    public override func interactive(cancel velocity: CGPoint) {
        super.interactive(cancel: velocity)
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactAnimator?.timingCurve = provider
        self.interactAnimator?.cancel()
        self.interactAnimator = nil
    }

}
@available(iOS 10.0, *)
extension ModalNavigationContext: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactAnimator : nil
    }
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 这里 afterScreenUpdates 为true的时候就不会走自定义的动画
//        if operation == .push {
//            if let view = navigationController.view.snapshotView(afterScreenUpdates: false) {
//                snapshotView = view
//            }
//        } else {
//            snapshotView?.removeFromSuperview()
//        }
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
        if !self.animator.animationEnable {
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
        let isPresented = self.isShow
        let transitionView = transitionContext.containerView
        func completionBlock() {
            let success = !transitionContext.transitionWasCancelled
            if isPresented && !success {
                toVC.view.removeFromSuperview()
            }
            if self.isShow {
                if let showViewController = toVC as? WQLayoutController {
                    showViewController.isPushing = false
                }
            } else {
                 if let showViewController = fromVC as? WQLayoutController {
                    showViewController.isPoping = false
                }
            }
            currentNavigationController?.delegate = previousDelegate
            previousDelegate = nil
            transitionContext.completeTransition(success)
        }
        let toVCView = transitionContext.view(forKey: .to)
        if self.isShow {
            if let toView = toVCView {
                if transitionView !== toView {// 解决 多次动画 而把自己放在栈顶的问题
                   transitionView.addSubview(toView)
                }
            }
        } else {
            if let toView = toVCView,
               let fromView = transitionContext.view(forKey: .from) {
                transitionView.insertSubview(toView, belowSubview: fromView)
            }
        }
        if isPresented {
            toVCView?.frame = vcFinalFrame
            if let showViewController = toVC as? WQLayoutController {
                self.animator.preprocessor(.show, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            }
        } else {
            if let showViewController = fromVC as? WQLayoutController {
                self.animator.preprocessor(.hide, layoutController: showViewController, states: styleConfig, completion: completionBlock)
            } else {
                completionBlock()
            }
        }

    }
}
