//
//  UINavigationController+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/7/26.
//
#if canImport(UIKit) && !os(watchOS)
import Foundation
extension UINavigationController {
    /// SwifterSwift: Pop ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - animated: Set this value to true to animate the transition (default is true).
    ///   - completion: optional completion handler (default is nil).
    func popViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    /// SwifterSwift: Push ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewController: viewController to push.
    ///   - completion: optional completion handler (default is nil).
    func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    /// SwifterSwift: Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }
}

public extension WQModules where Base: UINavigationController {
     func popViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        self.base.popViewController(animated: animated, completion)
     }
     
     func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        self.base.pushViewController(viewController, completion: completion)
     }
}
#endif
