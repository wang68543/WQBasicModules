//
//  ModalInWindowContext.swift
//  Pods
//
//  Created by WQ on 2020/8/21.
//

import UIKit

/// 专职于显示Alert的Window
public class WQModalWindow: UIWindow {
    /// 记录的属性 用于消失之后恢复
    var previousKeyWindow: UIWindow?

    deinit {
        if let preKey = self.previousKeyWindow,
            UIApplication.shared.keyWindow === self {
            if preKey.isHidden {
                UIApplication.shared.delegate?.window??.makeKeyAndVisible()
            } else {
                preKey.makeKeyAndVisible()
            }
        }
        debugPrint("\(self):" + #function + "♻️")
    }
}
public extension WQModalWindow {
    /// 添加根控制器 并且让window显示
    func addVisible(root viewController: UIViewController) {
        self.previousKeyWindow = WQUIHelp.topNormalWindow()
        self.rootViewController = viewController
        if !self.isKeyWindow { //重复设置root
          self.makeKeyAndVisible()
        }
    }
    func remove() {
        let win = WQUIHelp.topNormalWindow()
        if let preKey = self.previousKeyWindow,
           win === self {
            if preKey.isHidden {
                UIApplication.shared.delegate?.window??.makeKeyAndVisible()
            } else {
                preKey.makeKeyAndVisible()
            }
        }
        self.isHidden = true
        if #available(iOS 13.0, *) { } else {
            // todo: - 这里在iOS13下 设置rootViewController为nil 会自动调用 rootViewController 的dismiss
            self.rootViewController = nil
        }
        self.previousKeyWindow = nil
    }
}
@available(iOS 10.0, *)
public class ModalInWindowContext: ModalDrivenContext {
    var keyWindow: WQModalWindow?
    func getKeyWindow() -> WQModalWindow? {
        if keyWindow == nil {
            let win = WQModalWindow()
            let view = WQUIHelp.topNormalWindow()
            if let snapshot = view?.snapshotView(afterScreenUpdates: true) {
                UIView.performWithoutAnimation {
                    win.addSubview(snapshot)
                }
            }
           keyWindow = win
        }
        return keyWindow
    }
 
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        guard !controller.isMovingToWindow else { return }
        controller.isMovingToWindow = true
        super.show(controller, statesConfig: statesConfig, completion: completion)
        let viewController = self.viewController(controller)
        getKeyWindow()?.addVisible(root: viewController)
        self.animator.preprocessor(.show, layoutController: controller, states: statesConfig) {
            controller.isMovingToWindow = false
            completion?()
        }
    }
    public override func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        guard !controller.isMovingToWindow else { return }
        controller.isMovingToWindow = true
        super.interactive(present: controller, statesConfig: states)
        UIView.performWithoutAnimation {
            let viewController = self.viewController(controller)
            getKeyWindow()?.addVisible(root: viewController)
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
        guard !controller.isMovingFromWindow else { return true }
        controller.isMovingFromWindow = true
        super.hide(controller, animated: flag, completion: completion)
        self.animator.preprocessor(.hide, layoutController: controller, states: self.styleConfig) { [weak self] in
            guard let `self` = self else { return }
            controller.isMovingFromWindow = false
            completion?()
            self.getKeyWindow()?.remove()
            self.keyWindow = nil
            self.navgationController = nil
        }
        return true
    }
    public override func interactive(dismiss controller: WQLayoutController) {
        guard !controller.isMovingFromWindow else { return }
        if interactiveAnimator?.isRunning == true {
            interactiveAnimator?.stopAnimation(true)
        }
        controller.isMovingFromWindow = true
        super.interactive(dismiss: controller)
        interactiveAnimator = UIViewPropertyAnimator(duration: self.animator.duration, curve: .easeOut, animations: { [weak self] in
            guard let `self` = self else { return }
            self.styleConfig.states.setup(forState: .hide)
        })
    }
    public override func interactive(finish velocity: CGPoint) {
        super.interactive(finish: velocity)
        self.interactiveAnimator?.addCompletion { [weak self] position in
            guard let `self` = self,
                  position == .end else { return }
            if !self.isShow {
                self.layoutViewController?.isMovingFromWindow = false
                self.getKeyWindow()?.remove()
                self.keyWindow = nil
            } else {
                self.layoutViewController?.isMovingToWindow = false
            }
            self.interactiveAnimator = nil
        }
        self.continueAnimation(velocity)
    }
    public override func interactive(cancel velocity: CGPoint) {
        super.interactive(cancel: velocity)
        self.interactiveAnimator?.addCompletion { [weak self] position in
            guard let `self` = self,
                  position == .start else { return }
            if !self.isShow {
                self.layoutViewController?.isMovingFromWindow = false
            } else {
                self.layoutViewController?.isMovingToWindow = false
                self.getKeyWindow()?.remove()
                self.keyWindow = nil
            }
            self.interactiveAnimator = nil
        }
        self.interactiveAnimator?.isReversed = true
        self.continueAnimation(velocity)
    }
}
