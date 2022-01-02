//
//  UINavigationController+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/7/26.
//
#if canImport(UIKit) && !os(watchOS)
import SwifterSwift
import Foundation
public extension WQModules where Base: UINavigationController {
     func popViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        self.base.popViewController(animated: animated, completion)
     }

     func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        self.base.pushViewController(viewController, completion: completion)
     }
}
#endif
