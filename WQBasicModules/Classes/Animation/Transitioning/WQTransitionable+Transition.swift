//
//  WQPresentationable+Transition.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2019/1/20.
//

import Foundation
public typealias TransitionCompleted = (() -> Void)
// MARK: - -- 提供给外部使用的接口
extension WQTransitionable {
    /// modal 形式显示当前控制器
    public func presentSelf(in controller: UIViewController, animated flag: Bool, completion: TransitionCompleted?) {
        self.showMode = .present
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        controller.present(self, animated: flag, completion: completion)
    }
    
    /// 让被弹出的控制器与当前控制器成为兄弟控制器(即以当前父控制器的子控制器显示(当当前是根控制器的时候以当前的子控制器形式显示))
    ///
    /// - Parameters:
    ///   - controller: 当前控制器
    ///   - flag: 是否动画
    ///   - completion: 显示完成
    public func shownInParent(_ controller: UIViewController, animated flag: Bool, completion: TransitionCompleted?) {
        self.showMode = .superChildController
        var topVC: UIViewController
        var animatedVC: UIViewController?
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
        usingTransitionAnimatedController = animatedVC
        let isAppearanceTransition = self.shouldViewWillApperance
        if isAppearanceTransition {
            topVC.beginAppearanceTransition(false, animated: flag)
            self.beginAppearanceTransition(true, animated: flag)
        }
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.didMove(toParent: topVC)
            }
            if isAppearanceTransition {
                self.endAppearanceTransition()
                topVC.endAppearanceTransition()
            }
            completion?()
        }
        topVC.addChild(self)
        topVC.view.addSubview(self.view)
        if shouldAdvanceLayout {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            topVC.view.layoutIfNeeded()
            CATransaction.commit()
        }
        self.showAnimated(flag, presented: topVC, completion: animateFinshed(_:))
    }
    
    /// 被弹出的控制器以新建keyWindow的根控制器的形式显示
    public func shownInWindow(animated flag: Bool, completion: TransitionCompleted?) {
        self.showMode = .windowRootController
        let preRootViewController = UIApplication.shared.delegate?.window??.rootViewController
        self.usingTransitionAnimatedController = preRootViewController
        let isAppearanceTransition = self.shouldViewWillApperance
        if isAppearanceTransition {
            preRootViewController?.beginAppearanceTransition(false, animated: flag) // 当前控制器会直接调用viewAppear
        }
        self.previousKeyWindow = UIApplication.shared.keyWindow
        if self.containerWindow == nil {
            self.containerWindow = WQTransitionWindow(frame: UIScreen.main.bounds)
            self.containerWindow?.windowLevel = WQContainerWindowLevel
            self.containerWindow?.backgroundColor = .clear;// 避免横竖屏旋转时出现黑色
        }
        self.containerWindow?.rootViewController = self
        self.containerWindow?.makeKeyAndVisible()
        func animateFinshed(_ flag: Bool) {
            if !flag {
                self.clearShowWindow()
            }
            if isAppearanceTransition {
                preRootViewController?.endAppearanceTransition()
            }
            completion?()
        }
        self.showAnimated(flag, presented: preRootViewController, completion: animateFinshed(_:))
    } 
    /// 直接以当前控制器的子控制器的形式显示(与当前控制器的界面显示同步)
    public func showInController(_ controller: UIViewController, animated flag: Bool, completion: TransitionCompleted?) {
        self.showMode = .childController
        let isAppearanceTransition = self.shouldViewWillApperance
        usingTransitionAnimatedController = controller
        if isAppearanceTransition {
            self.beginAppearanceTransition(true, animated: flag)
        }
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.didMove(toParent: controller)
            }
            if isAppearanceTransition {
                self.endAppearanceTransition()
            }
            completion?()
        }
        controller.addChild(self)
        controller.view.addSubview(self.view)
        if controller is UITabBarController {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            controller.view.layoutIfNeeded()
            CATransaction.commit()
        }
        self.showAnimated(flag, presented: controller, completion: animateFinshed(_:))
    }
    internal func hideFromParent(animated flag: Bool, completion: TransitionCompleted? ) {
        let other = self.usingTransitionAnimatedController
        let isAppearanceTransition = self.shouldViewWillApperance
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
            if isAppearanceTransition {
                other?.endAppearanceTransition()
                self.endAppearanceTransition()
            }
            completion?()
        }
        if isAppearanceTransition {
            self.beginAppearanceTransition(false, animated: flag)
            other?.beginAppearanceTransition(true, animated: flag)
        }
        self.willMove(toParent: nil)
        self.hideAnimated(flag, other: other, completion: animateFinshed(_:))
    }
    internal func hideFromWindow(animated flag: Bool, completion: TransitionCompleted?) {
        let other = self.usingTransitionAnimatedController
        let isAppearanceTransition = self.shouldViewWillApperance
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.clearShowWindow()
            }
            if isAppearanceTransition {
                other?.endAppearanceTransition()
            }
            completion?()
        }
        if isAppearanceTransition {
            other?.beginAppearanceTransition(true, animated: flag)
        }
        self.hideAnimated(flag, other: other, completion: animateFinshed(_:))
    }
   
    internal func hideFromController(animated flag: Bool, completion: TransitionCompleted?) {
        let other = self.usingTransitionAnimatedController
        let isAppearanceTransition = self.shouldViewWillApperance
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
            if isAppearanceTransition {
                other?.endAppearanceTransition()
                self.endAppearanceTransition()
            }
            completion?()
        }
        if isAppearanceTransition {
            self.beginAppearanceTransition(false, animated: flag)
            other?.beginAppearanceTransition(true, animated: flag)
        }
        self.willMove(toParent: nil)
        self.hideAnimated(flag, other: other, completion: animateFinshed(_:))
    }
}

private extension WQTransitionable {
    func clearShowWindow() {
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
    
    func hideAnimated(_ flag: Bool, other: UIViewController?, completion: @escaping ((Bool) -> Void)) {
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.hidenDriven as? WQPropertyDriven {
                driven.startIneractive(presented: other, presenting: self) { completion($0 == .end) }
            } else {
                self.animator.animated(presented: other, presenting: self, isShow: false) { completion($0) }
            }
        } else {
            self.animator.items.config(other, presenting: self, isShow: false)
            completion(true)
        }
    }
    
    func showAnimated(_ flag: Bool, presented inVC: UIViewController?, completion: @escaping ((Bool) -> Void)) {
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.showDriven as? WQPropertyDriven {
                driven.startIneractive(presented: inVC, presenting: self) { completion($0 == .end) }
            } else {
                self.animator.animated(presented: inVC, presenting: self, isShow: true) { completion($0) }
            }
        } else {
            self.animator.items.config(inVC, presenting: self, isShow: true)
            completion(true)
        }
        // 10以下 不支持手势驱动
        if #available(iOS 10.0, *) { } else { interactionDismissDirection = nil }
    }
}
