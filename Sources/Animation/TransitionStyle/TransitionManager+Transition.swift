//
//  TransitionManager+Transition.swift
//  Pods
//
//  Created by WQ on 2019/9/6.
//

import Foundation
public extension TransitionManager {
    func show(in viewController: UIViewController, animated flag: Bool, completion: Completion?) {
        self.showFromViewController = viewController 
    }
    func present(by viewController: UIViewController?, animated flag: Bool, completion: Completion?) {
        self.showFromViewController = viewController ?? defaultPresentViewController()
        self.transitionStyle = .customModal
        self.showViewController.modalPresentationStyle = .custom
        self.showFromViewController?.transitioningDelegate = self
        self.showViewController.modalPresentationStyle = .custom
        self.showViewController.transitioningDelegate = self
        self.showFromViewController?.present(self.showViewController, animated: flag, completion: {
            completion?(true)
        })
    }
    /// 默认为一个全屏的透明的window
    func show(with window: WQTransitionWindow? = nil) {
        self.containerWindow = window ?? defaultWindow()
    }
}
extension TransitionManager {
    private func defaultWindow() -> WQTransitionWindow {
        let window = WQTransitionWindow(frame: UIScreen.main.bounds)
        return window
    }
    
    private func defaultPresentViewController() -> UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }
}
