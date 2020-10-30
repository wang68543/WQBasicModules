//
//  UIView+Modal.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/9/8.
//

import Foundation
public extension UIView {
    struct AssociatedKeys {
        static let presenter = UnsafeRawPointer(bitPattern: "wq.modal.presenter".hashValue)!
    }
//    func alert() {
//
//    }
//    func actionSheet() {
//
//    }
//    func present() {
//
//    }
//    func show(_ config: ModalConfig, )
}
public extension UIView {
    func present(_ config: ModalContext, animation: TransitionAnimationPreprocessor, parent: UIViewController?) {
        
    }
    
}
