//
//  UIView+Modal.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/9/8.
//

import Foundation
 
public extension UIView {
    struct AssociatedKeys {
        static let layoutFittingMaxmiumSize = UnsafeRawPointer(bitPattern: "wq.view.properties.layoutFittingMaxmiumSize".hashValue)!
    }
    var modalSize: CGSize {
        if !self.bounds.isEmpty {
            return self.bounds.size
        } else {
            let size = self.layoutFittingMaxmiumSize
            if size == .zero {
                let sysSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .fittingSizeLevel)
                return sysSize
            } else {
                let horizontal: UILayoutPriority = size.width == .zero ? .fittingSizeLevel : .required
                let vertical: UILayoutPriority = size.height == .zero ? .fittingSizeLevel : .required
                let sysSize = self.systemLayoutSizeFitting(size, withHorizontalFittingPriority: horizontal, verticalFittingPriority: vertical)
                return sysSize
            }
        }
    }
    /// 用于modal弹窗 自动布局的时候 弹窗的自适应最大尺寸 默认最大尺寸是全屏
    var layoutFittingMaxmiumSize: CGSize {
        set {
            //这里内存由外部管理
            objc_setAssociatedObject(self, AssociatedKeys.layoutFittingMaxmiumSize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let value = objc_getAssociatedObject(self, AssociatedKeys.layoutFittingMaxmiumSize) as? CGSize else {
                return .zero
            }
            return value
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
    /// 弹窗尺寸自动布局的时候 宽度约束
    var constraintLayoutWidth: CGFloat {
        set {
            var size = self.base.layoutFittingMaxmiumSize
            size.width = newValue
            self.base.layoutFittingMaxmiumSize = size
        }
        get {
            return self.base.layoutFittingMaxmiumSize.width
        }
    }
    /// 弹窗尺寸自动布局的时候 高度约束
    var constraintLayoutHeight: CGFloat {
        set {
            var size = self.base.layoutFittingMaxmiumSize
            size.height = newValue
            self.base.layoutFittingMaxmiumSize = size
        }
        get {
            return base.layoutFittingMaxmiumSize.height
        }
    }
    
    /// 直接指定Modal View最终显示的尺寸
    var constraintBoundSize: CGSize {
        set {
            self.base.bounds.size = newValue
        }
        get {
            return self.base.bounds.size
        }
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
