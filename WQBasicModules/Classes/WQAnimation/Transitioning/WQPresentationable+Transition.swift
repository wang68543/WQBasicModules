//
//  WQPresentationable+Transition.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2019/1/20.
//

import Foundation
public typealias TransitionCompleted = (() -> Void)
// MARK: - -- 提供给外部使用的接口
extension WQPresentationable {
    public func presentSelf(in controller: UIViewController, flag: Bool, completion: TransitionCompleted?) {
        self.shownMode = .present
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        controller.present(self, animated: flag, completion: completion)
    }
    public func shownInParent(_ controller: UIViewController, flag: Bool, completion: TransitionCompleted?) {
        self.shownMode = .superChildController
        var topVC: UIViewController
        var animatedVC: UIViewController?
        //保证使用全屏的View
        // 尽量确保层级是navigationController的子控制器 并动画的是navigationController的子控制器
        var shouldAdvanceLayout: Bool = false
        if let navgationController = controller.navigationController {
            topVC = navgationController
            animatedVC = navgationController.visibleViewController
        } else if let tabBarController = controller.tabBarController {
            shouldAdvanceLayout = true // tabBarController在增加了子控制器之后会刷新布局从而覆盖动画的效果 所以需要在动画之前刷新一遍
            topVC = tabBarController
            animatedVC = tabBarController.selectedViewController ?? controller
        } else {
            topVC = controller.parent ?? controller
            animatedVC = controller.topVisible()
        }
        //这里 controller如果当前是根控制器 则关于presented的frame 动画可能会出现异常
        shouldUsingPresentionAnimatedController = animatedVC
        topVC.addChild(self)
        topVC.view.addSubview(self.view)
        if shouldAdvanceLayout {
            CATransaction.begin()
            CATransaction.disableActions()
            topVC.view.layoutIfNeeded()
            CATransaction.commit()
        }
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.showInteractive as? WQPropertyDriven,
                driven.isInteractive {
                driven.startIneractive(presented: topVC, presenting: self) { [weak self] position in
                    if let weakSelf = self,
                        position == .end {
                        weakSelf.didMove(toParent: topVC)
                    }
                    completion?()
                }
            } else {
                self.animator.animated(presented: topVC, presenting: self, isShow: true) { [weak self] _ in
                    if let weakSelf = self  {
                        weakSelf.didMove(toParent: topVC)
                    }
                    completion?()
                }
            }
        } else {
            self.animator.items.config(animatedVC, presenting: self, isShow: true)
            self.didMove(toParent: topVC)
            completion?()
        }
        if #available(iOS 10.0, *) {
            
        } else {
            interactionDissmissDirection = nil
        } 
    }
    public func shownInWindow(_ flag: Bool, completion: TransitionCompleted?) {
        self.shownMode = .windowRootController
        self.previousKeyWindow = UIApplication.shared.keyWindow
        if self.containerWindow == nil {
            self.containerWindow = WQPresentationWindow(frame: UIScreen.main.bounds)
            self.containerWindow?.windowLevel = WQContainerWindowLevel
            self.containerWindow?.backgroundColor = .clear;// 避免横竖屏旋转时出现黑色
        }
        self.containerWindow?.rootViewController = self
        self.containerWindow?.makeKeyAndVisible()
        let preRootViewController = UIApplication.shared.delegate?.window??.rootViewController
        self.shouldUsingPresentionAnimatedController = preRootViewController
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.showInteractive as? WQPropertyDriven,
                driven.isInteractive {
                driven.startIneractive(presented: preRootViewController, presenting: self) { [weak self] position in
                    if let weakSelf = self,
                        position != .end {
                        weakSelf.clearShowWindow()
                    }
                    completion?()
                }
            } else {
                self.animator.animated(presented: preRootViewController, presenting: self, isShow: true) { _ in
                    completion?()
                }
            }
        } else {
            self.animator.items.config(preRootViewController, presenting: self, isShow: true)
            completion?()
        }
        if #available(iOS 10.0, *) {
            
        } else {
            interactionDissmissDirection = nil
        }
    }
    //直接显示在指定的控制器上 保持页面的显示同步
    public func showInController(_ controller: UIViewController?, flag: Bool, completion: TransitionCompleted?) {
        self.shownMode = .childController
        guard let top = controller ?? WQUIHelp.topVisibleViewController() else {
            completion?()
            return
        }
        shouldUsingPresentionAnimatedController = top
        top.addChild(self)
        top.view.addSubview(self.view)
        if top is UITabBarController {
            CATransaction.begin()
            CATransaction.disableActions()
            top.view.layoutIfNeeded()
            CATransaction.commit()
        }
        if flag {
            if #available(iOS 10.0, *),
               let driven = self.showInteractive as? WQPropertyDriven,
               driven.isInteractive {
                driven.startIneractive(presented: top, presenting: self) { [weak self] position in
                    if let weakSelf = self,
                        position == .end {
                        weakSelf.didMove(toParent: top)
                    }
                    completion?()
                }
            } else {
                self.animator.animated(presented: top, presenting: self, isShow: true) { [weak self] _ in
                    if let weakSelf = self  {
                        weakSelf.didMove(toParent: top)
                    }
                    completion?()
                }
            }
        } else {
            self.animator.items.config(top, presenting: self, isShow: true)
            self.didMove(toParent: top)
            completion?()
        }
        if #available(iOS 10.0, *) {
            
        } else {
            interactionDissmissDirection = nil
        }
    }
    internal func hideFromParent(animated flag: Bool, completion: TransitionCompleted? ) {
        func animateFinshed(_ flag: Bool) {
            self.view.removeFromSuperview()
            self.removeFromParent()
            completion?()
        }
        self.willMove(toParent: nil)
        let other = self.shouldUsingPresentionAnimatedController
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.hidenDriven as? WQPropertyDriven {
                driven.startIneractive(presented: other, presenting: self) { position in
                    animateFinshed(position == .end)
                }
            } else {
                self.animator.animated(presented: other,  presenting: self, isShow: false) { _ in
                    animateFinshed(true)
                }
            }
        } else {
            self.animator.items.config(other, presenting: self, isShow: false)
            animateFinshed(true)
        }
    }
    internal func hideFromWindow(animated flag: Bool, completion: TransitionCompleted?) {
        func animateFinshed(_ flag: Bool) {
            self.clearShowWindow()
            completion?()
        }
        let other = self.shouldUsingPresentionAnimatedController
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.hidenDriven as? WQPropertyDriven {
                driven.startIneractive(presented: other, presenting: self) { position in
                    animateFinshed(position == .end)
                }
            } else {
                self.animator.animated(presented: other,  presenting: self, isShow: false) { _ in
                    animateFinshed(true)
                }
            }
        } else {
            self.animator.items.config(other, presenting: self, isShow: false)
            animateFinshed(true)
        }
    }
    private func clearShowWindow() {
        if UIApplication.shared.keyWindow === self.containerWindow {
            if let isPreviousHidden = self.previousKeyWindow?.isHidden,
                isPreviousHidden {
                UIApplication.shared.delegate?.window??.makeKey()
            } else {
                self.previousKeyWindow?.makeKey()
            }
        }
        self.containerWindow?.isHidden = true
        self.containerWindow?.rootViewController = nil
        self.previousKeyWindow = nil
    }
    internal func hideFromController(animated flag: Bool, completion: TransitionCompleted?) {
        func animateFinshed(_ flag: Bool) {
            self.view.removeFromSuperview()
            self.removeFromParent()
            completion?()
        }
        self.willMove(toParent: nil)
        let other = self.shouldUsingPresentionAnimatedController
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.hidenDriven as? WQPropertyDriven,
                driven.isInteractive {
                driven.startIneractive(presented: other, presenting: self) { position in
                    animateFinshed(position == .end)
                }
            } else {
                self.animator.animated(presented: other,  presenting: self, isShow: false) { _ in
                    animateFinshed(true)
                }
            }
        } else {
            self.animator.items.config(other, presenting: self, isShow: false)
            animateFinshed(true)
        }
    }
}
