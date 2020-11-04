//
//  UIView+Modal.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/9/8.
//

import Foundation
public extension UIView {
//    struct AssociatedKeys {
//        static let modal = UnsafeRawPointer(bitPattern: "wq.modal.config".hashValue)!
//    }
    var modal: TransitionManager? {
        var layout: UIResponder? = self
        while let nextView = layout?.next {
            layout = nextView
            if nextView is WQLayoutController {  break }
        }
        return (layout as? WQLayoutController)?.manager
    }
}
public extension UIView {
    
    func alert(_ config: ModalConfig = .default, completion: TransitionAnimation.Completion? = nil) {
        let states = TransitionStatesConfig()
        let layout = WQLayoutController(config, states: states)
//        layout.manager
    }
    
    func actionSheet(_ config: ModalConfig = .default, completion: TransitionAnimation.Completion? = nil) {

    }
    
    func present(_ config: ModalConfig, anmation: TransitionAnimation) {
        
    }
}
public extension UIView {
    func present(_ manger: TransitionManager, animation: TransitionAnimation) {
        
    }
//    func dismiss()
    
}
