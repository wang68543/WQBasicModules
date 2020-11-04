//
//  UIView+Modal.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/9/8.
//

import Foundation
public extension UIView {
    struct AssociatedKeys {
        static let modal = UnsafeRawPointer(bitPattern: "wq.modal.config".hashValue)!
    }
    var modal: ModalConfig? {
        return objc_getAssociatedObject(self, AssociatedKeys.modal) as? ModalConfig
    }
}
public extension UIView {
    
    func alert(_ config: ModalConfig = .default, completion: TransitionAnimation.Completion? = nil) {

    }
    
    func actionSheet(_ config: ModalConfig = .default, completion: TransitionAnimation.Completion? = nil) {

    }
    
    func present(_ config: ModalConfig, anmation: TransitionAnimation) {
        
    }
}
public extension UIView {
    func present(_ config: ModalContext, animation: TransitionAnimation, parent: UIViewController?) {
        
    }
    
}
