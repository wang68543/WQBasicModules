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
        return nextLayoutController?.manager
    }
    
    var modalSize: CGSize {
        if !self.bounds.isEmpty {
            return self.bounds.size
        } else {
            let sysSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return sysSize
        }
    }
    
    var nextLayoutController: WQLayoutController? {
        var layout: UIResponder? = self
        while let nextView = layout?.next {
            layout = nextView
            if nextView is WQLayoutController {  break }
        }
        return (layout as? WQLayoutController)
    }
}
public extension UIView {
    
    func alert(_ flag: Bool, config: ModalConfig, completion: TransitionAnimation.Completion? = nil) {
        let states = TransitionStatesConfig(.alert, anmation: .fade)
        let layout = WQLayoutController(config, states: states)
        self.present(flag, container: layout, completion: completion)
    }
    
    func actionSheet(_ flag: Bool, config: ModalConfig, completion: TransitionAnimation.Completion? = nil) {
        let states = TransitionStatesConfig(.alert, anmation: .fade)
        let layout = WQLayoutController(config, states: states)
        self.present(flag, container: layout, completion: completion)
    }
    
    func present(_ flag: Bool, container: WQLayoutController, completion: TransitionAnimation.Completion? = nil) {
        container.modal(flag, comletion: completion)
    }
    
    func dismiss(_ flag: Bool, completion: TransitionAnimation.Completion? = nil) {
        self.nextLayoutController?.dismiss(animated: flag, completion: completion)
    }
} 
