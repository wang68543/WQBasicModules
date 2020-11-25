//
//  ModalInWindowContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
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
                UIApplication.shared.delegate?.window??.makeKey()
            } else {
                preKey.makeKey()
            }
        }
    }
}
public extension WQModalWindow {
    /// 添加根控制器 并且让window显示
    func addVisible(root viewController: UIViewController) {
        #if targetEnvironment(macCatalyst)
        let win = UIApplication.shared.windows.last
        #else
        let win = UIApplication.shared.keyWindow
        #endif
        self.previousKeyWindow = win
        self.rootViewController = viewController
        if !self.isKeyWindow { //重复设置root
          self.makeKeyAndVisible()
        }
    }
    func remove() {
        #if targetEnvironment(macCatalyst)
        let win = UIApplication.shared.windows.last
        #else
        let win = UIApplication.shared.keyWindow
        #endif
        if let preKey = self.previousKeyWindow,
           win === self {
            if preKey.isHidden {
                UIApplication.shared.delegate?.window??.makeKey()
            } else {
                preKey.makeKey()
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
public class ModalInWindowContext: ModalDrivenContext {
    lazy var window: WQModalWindow = {
       let win = WQModalWindow()
        win.backgroundColor = .clear
        return win
    }()
    public override func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        self.window.addVisible(root: controller)
        self.animator.preprocessor(.show, layoutController: controller, states: statesConfig, completion: completion)
    }
    public override func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) -> Bool {
        self.animator.preprocessor(.hide, layoutController: controller, states: self.styleConfig) { [weak self] in
            completion?()
            self?.window.remove()
        }
        return true
    } 
}
