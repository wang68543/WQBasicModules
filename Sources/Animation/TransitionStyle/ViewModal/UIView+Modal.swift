//
//  UIView+Modal.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/9/8.
//

import Foundation
 
public extension UIView {

    var modalSize: CGSize {
        if !self.bounds.isEmpty {
            return self.bounds.size
        } else {
            let sysSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return sysSize
        }
    }
    var layoutController: WQLayoutController? {
        var layout: UIResponder? = self
        while let nextView = layout?.next {
            layout = nextView
            if nextView is WQLayoutController {  break }
        }
        return (layout as? WQLayoutController)
    }
}
public extension WQModules where Base: UIView {
    
    func alert(_ flag: Bool, config: ModalConfig = .default, completion: ModalAnimation.Completion? = nil) {
        let states = StyleConfig(.alert, anmation: .default)
        self.present(config, states: states, completion: completion)
    }
    
    func actionSheet(_ flag: Bool, config: ModalConfig = .default, completion: ModalAnimation.Completion? = nil) {
        let states = StyleConfig(.actionSheet, anmation: .default)
        self.present(config, states: states, completion: completion)
    }
    
    func present(_ config: ModalConfig, states: StyleConfig, completion: ModalAnimation.Completion? = nil) {
        let layout = WQLayoutController(config, subView: self.base)
        present(layout, states: states, completion: completion)
    }
    func present(_ container: WQLayoutController, states: StyleConfig, completion: ModalAnimation.Completion? = nil) {
        container.modal(states, comletion: completion)
    } 
    func dismiss(style: Bool, completion: ModalAnimation.Completion? = nil) {
        self.base.layoutController?.dismiss(animated: style, completion: completion)
    }
} 
