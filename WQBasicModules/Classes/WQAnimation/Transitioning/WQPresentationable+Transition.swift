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
    /// modal 形式显示当前控制器
    public func presentSelf(in controller: UIViewController, animated flag: Bool, completion: TransitionCompleted?) {
        self.shownMode = .present
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
    //  swiftlint:disable function_body_length
    public func shownInParent(_ controller: UIViewController, animated flag: Bool, completion: TransitionCompleted?) {
        self.shownMode = .superChildController
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
        shouldUsingPresentionAnimatedController = animatedVC
        let isAppearanceTransition = self.shouldViewWillApperance
        if isAppearanceTransition {
            topVC.beginAppearanceTransition(false, animated: flag)
            self.beginAppearanceTransition(true, animated: flag)
        }
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.didMove(toParent: topVC)
                if isAppearanceTransition {
                    self.endAppearanceTransition()
                    topVC.endAppearanceTransition()
                }
            }
            completion?()
        }
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
                let driven = self.showInteractive as? WQPropertyDriven {
                driven.startIneractive(presented: topVC, presenting: self) { animateFinshed($0 == .end) }
            } else {
                self.animator.animated(presented: topVC, presenting: self, isShow: true) { animateFinshed($0) }
            }
        } else {
            self.animator.items.config(animatedVC, presenting: self, isShow: true)
            animateFinshed(true)
        }
        if #available(iOS 10.0, *) { } else { interactionDissmissDirection = nil } 
    }
    
    /// 被弹出的控制器以新建keyWindow的根控制器的形式显示
    public func shownInWindow(animated flag: Bool, completion: TransitionCompleted?) {
        self.shownMode = .windowRootController
        let preRootViewController = UIApplication.shared.delegate?.window??.rootViewController
        self.shouldUsingPresentionAnimatedController = preRootViewController
        let isAppearanceTransition = self.shouldViewWillApperance
        if isAppearanceTransition {
            preRootViewController?.beginAppearanceTransition(false, animated: flag) // 当前控制器会直接调用viewAppear
        }
        self.previousKeyWindow = UIApplication.shared.keyWindow
        if self.containerWindow == nil {
            self.containerWindow = WQPresentationWindow(frame: UIScreen.main.bounds)
            self.containerWindow?.windowLevel = WQContainerWindowLevel
            self.containerWindow?.backgroundColor = .clear;// 避免横竖屏旋转时出现黑色
        }
        self.containerWindow?.rootViewController = self
        self.containerWindow?.makeKeyAndVisible()
        func animateFinshed(_ flag: Bool) {
            if !flag {
                self.clearShowWindow()
            } else {
                if isAppearanceTransition {
                    preRootViewController?.endAppearanceTransition()
                }
            }
            completion?()
        }
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.showInteractive as? WQPropertyDriven {
                driven.startIneractive(presented: preRootViewController, presenting: self) { animateFinshed($0 == .end) }
            } else {
                self.animator.animated(presented: preRootViewController, presenting: self, isShow: true) { animateFinshed($0) }
            }
        } else {
            self.animator.items.config(preRootViewController, presenting: self, isShow: true)
            animateFinshed(true)
        }
        if #available(iOS 10.0, *) { } else { interactionDissmissDirection = nil }
    }
    
    /// 直接以当前控制器的子控制器的形式显示(与当前控制器的界面显示同步)
    public func showInController(_ controller: UIViewController, animated flag: Bool, completion: TransitionCompleted?) {
        self.shownMode = .childController
        let isAppearanceTransition = self.shouldViewWillApperance
        shouldUsingPresentionAnimatedController = controller
        if isAppearanceTransition {
            self.beginAppearanceTransition(true, animated: flag)
        }
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.didMove(toParent: controller)
                if isAppearanceTransition {
                  self.endAppearanceTransition()
                }
            }
            completion?()
        }
        controller.addChild(self)
        controller.view.addSubview(self.view)
        if controller is UITabBarController {
            CATransaction.begin()
            CATransaction.disableActions()
            controller.view.layoutIfNeeded()
            CATransaction.commit()
        }
        if flag {
            if #available(iOS 10.0, *),
               let driven = self.showInteractive as? WQPropertyDriven {
                driven.startIneractive(presented: controller, presenting: self) { animateFinshed($0 == .end) }
            } else {
                self.animator.animated(presented: controller, presenting: self, isShow: true) { animateFinshed($0) }
            }
        } else {
            self.animator.items.config(controller, presenting: self, isShow: true)
           animateFinshed(true)
        }
        if #available(iOS 10.0, *) { } else { interactionDissmissDirection = nil }
    }
    internal func hideFromParent(animated flag: Bool, completion: TransitionCompleted? ) {
        let other = self.shouldUsingPresentionAnimatedController
        let isAppearanceTransition = self.shouldViewWillApperance
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.view.removeFromSuperview()
                self.removeFromParent()
                if isAppearanceTransition {
                    other?.endAppearanceTransition()
                    self.endAppearanceTransition()
                }
            }
            completion?()
        }
        if isAppearanceTransition {
            self.beginAppearanceTransition(false, animated: flag)
            other?.beginAppearanceTransition(true, animated: flag)
        }
        self.willMove(toParent: nil) 
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.hidenDriven as? WQPropertyDriven {
                driven.startIneractive(presented: other, presenting: self) { animateFinshed($0 == .end) }
            } else {
                self.animator.animated(presented: other, presenting: self, isShow: false) { animateFinshed($0) }
            }
        } else {
            self.animator.items.config(other, presenting: self, isShow: false)
            animateFinshed(true)
        }
    }
    internal func hideFromWindow(animated flag: Bool, completion: TransitionCompleted?) {
        let other = self.shouldUsingPresentionAnimatedController
        let isAppearanceTransition = self.shouldViewWillApperance
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.clearShowWindow()
                if isAppearanceTransition {
                    other?.endAppearanceTransition()
                }
            }
            completion?()
        }
        if isAppearanceTransition {
            other?.beginAppearanceTransition(true, animated: flag)
        }
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.hidenDriven as? WQPropertyDriven {
                driven.startIneractive(presented: other, presenting: self) { animateFinshed($0 == .end) }
            } else {
                self.animator.animated(presented: other, presenting: self, isShow: false) { animateFinshed($0) }
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
        let other = self.shouldUsingPresentionAnimatedController
        let isAppearanceTransition = self.shouldViewWillApperance
        func animateFinshed(_ flag: Bool) {
            if flag {
                self.view.removeFromSuperview()
                self.removeFromParent()
                if isAppearanceTransition {
                    other?.endAppearanceTransition()
                    self.endAppearanceTransition()
                }
            }
            completion?()
        }
        if isAppearanceTransition {
            self.beginAppearanceTransition(false, animated: flag)
            other?.beginAppearanceTransition(true, animated: flag)
        }
        self.willMove(toParent: nil)
        if flag {
            if #available(iOS 10.0, *),
                let driven = self.hidenDriven as? WQPropertyDriven {
                driven.startIneractive(presented: other, presenting: self) { animateFinshed($0 == .end) }
            } else {
                self.animator.animated(presented: other, presenting: self, isShow: false) { animateFinshed($0) }
            }
        } else {
            self.animator.items.config(other, presenting: self, isShow: false)
            animateFinshed(true)
        }
    }
}
