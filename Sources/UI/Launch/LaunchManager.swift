//
//  ShowWindowManager.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/4/15.
//

import Foundation
import UIKit
open class ShowWindowController: UIViewController {
    open override var shouldAutorotate: Bool {
        return false
    }
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}
open class LaunchManager: NSObject {
    public static let `default` = LaunchManager()

    public private(set) var window: UIWindow?
    /// 展示复制启动屏
    public func showLaunchWindow(with viewController: UIViewController = ShowWindowController()) {
        let image = LaunchScreen.snapshotLaunch
        let imageView = UIImageView(image: image)
        imageView.frame = UIScreen.main.bounds
        launchWindow(with: viewController)
        window?.addSubview(imageView)
        window?.sendSubviewToBack(imageView)
    }
    public func launchWindow(with viewController: UIViewController = ShowWindowController()) {
        window = UIWindow(frame: UIScreen.main.bounds, viewController)
        viewController.view.backgroundColor = .clear
//        viewController.view.isUserInteractionEnabled = false
        // windowLevel可以调整多个window的显示层级 
        window?.windowLevel = UIWindow.Level.statusBar + 1 // Level.statusBar + 1
//        window?.isHidden = false
//        window?.backgroundColor = .clear
//        window?.alpha = 1 
    }
    func removeOnly() {
        window?.removeFromApplication()
        window = nil
    }
    public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let nav = UIWindow.keyWindow?.topNavigationController
        nav?.pushViewController(viewController, animated: animated)
    }
    public func dismiss(duration: TimeInterval = 0.25, options: UIView.AnimationOptions = [], completion: (() -> Void)?) {
        guard let _window = window else { return }
        if options.isEmpty {
            self.removeOnly()
            completion?()
        } else {
            UIView.transition(with: _window, duration: duration, options: options) {
                _window.alpha = 0.0
            } completion: { _ in
                self.removeOnly()
                completion?()
            }
        }
    }
    public func dismissLite(_ duration: TimeInterval = 0.25, completion: (() -> Void)?) {
        guard let _window = window else { return }
        UIView.transition(with: _window, duration: duration, options: .curveEaseOut) {
            _window.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            _window.alpha = 0.0
        } completion: { _ in
            self.removeOnly()
            completion?()
        }
    }

}
