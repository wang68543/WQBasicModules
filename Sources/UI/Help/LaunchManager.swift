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
        let imageView = UIImageView(image: LaunchImage.snapshotLaunch)
        launchWindow(with: imageView)
    }
    public func launchWindow(with viewController: UIViewController = ShowWindowController()) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        viewController.view.backgroundColor = .clear
        viewController.view.isUserInteractionEnabled = false
        window?.windowLevel = UIWindow.Level.statusBar + 1
        window?.isHidden = false
        window?.backgroundColor = .clear
        window?.alpha = 1 
    }
    public func launchWindow(with view: UIView) {
        launchWindow()
        view.frame = UIScreen.main.bounds
        window?.addSubview(view)
    }
    func removeOnly() {
        window?.subviews.forEach { $0.removeFromSuperview() }
        window?.isHidden = true
        window = nil
    }
    public func dismiss(duration: TimeInterval = 0.25, option: UIView.AnimationOptions = [], completion: (() -> Void)?) {
        guard let _window = window else { return }
        UIView.transition(with: _window, duration: duration, options: option) {
            _window.alpha = 0.0
        } completion: { _ in
            self.removeOnly()
            completion?()
        }
    }
    public func dismissLite(_ duration: TimeInterval = 0.25, completion: (() -> Void)?)  {
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
