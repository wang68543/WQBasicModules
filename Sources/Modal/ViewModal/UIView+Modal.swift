//
//  UIView+Modal.swift
//  Pods
//
//  Created by WQ on 2020/9/8.
//

import Foundation
public extension UIView {
   private struct AssociatedKeys {
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
            // 这里内存由外部管理
            objc_setAssociatedObject(self, AssociatedKeys.layoutFittingMaxmiumSize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let value = objc_getAssociatedObject(self, AssociatedKeys.layoutFittingMaxmiumSize) as? CGSize else {
                return .zero
            }
            return value
        }
    }
    @available(iOS 10.0, *)
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
             self.base.layoutFittingMaxmiumSize.width
        }
    }
    /// 弹窗尺寸自
    /// .动布局的时候 高度约束
    var constraintLayoutHeight: CGFloat {
        set {
            var size = self.base.layoutFittingMaxmiumSize
            size.height = newValue
            self.base.layoutFittingMaxmiumSize = size
        }
        get {
             base.layoutFittingMaxmiumSize.height
        }
    }

    /// 直接指定Modal View最终显示的尺寸
    var constraintBoundSize: CGSize {
        set {
            self.base.bounds.size = newValue
        }
        get {
            self.base.bounds.size
        }
    }
}
@available(iOS 10.0, *)
public extension WQModules where Base: UIView {
    /// 弹窗
    func present(_ config: ModalConfig = .init(),
                 states: StyleConfig,
                 completion: ModalAnimation.Completion? = nil) {
        let layout = WQLayoutController(config, subView: self.base)
        // 配置默认配置
        states.setupStates(layout, config: config)
        present(layout, states: states, completion: completion)
    }

    func present(_ container: WQLayoutController, states: StyleConfig, completion: ModalAnimation.Completion? = nil) {
        container.modal(states, comletion: completion)
    }
    // 消失
    func dismissal(_ flag: Bool, completion: ModalAnimation.Completion? = nil) {
        self.base.layoutController?.hidden(animated: flag, completion: completion)
    }
}
@available(iOS 10.0, *)
public extension WQModules where Base: UIView {
    func alert(_ flag: Bool, config: ModalConfig = .init(), completion: ModalAnimation.Completion? = nil) {
        let states = StyleConfig(.alert, anmation: .default)
        states.animator.animationEnable = flag
        self.present(config, states: states, completion: completion)
    }
    /// 底部居中弹出
    func actionSheet(_ flag: Bool, config: ModalConfig = .init(), completion: ModalAnimation.Completion? = nil) {
        let states = StyleConfig(.actionSheet, anmation: .default)
        states.animator.animationEnable = flag
        self.present(config, states: states, completion: completion)
    }
    /// 拖拽显示
    func drag(present config: ModalConfig = .init(),
              states: StyleConfig) -> ModalContext? {
        let layout = WQLayoutController(config, subView: self.base)
        layout.startInteractive(states)
        return layout.context
    }
}

@available(iOS 10.0, *)
public extension WQModules where Base: UIView {
    /// pop弹出框
    /// - Parameters:
    ///   - sender: 从哪个view 弹出
    ///   - aliment: 弹出框与sender的对齐方式
    func popDown(from sender: UIView, aliment: PopAlignment, flag: Bool, config: ModalConfig = .init(), completion: ModalAnimation.Completion? = nil) {
        let rect: CGRect
        if config.style.inParent {
            guard let frame = sender.superview?.convert(sender.frame, to: config.fromViewController?.view) else { // 转换为当前控制器的坐标
                return
            }
            rect = frame
        } else {// 全局显示
            guard let frame = sender.superview?.convert(sender.frame, to: nil) else {
                return
            }
            rect = frame
        }
        self.popDown(to: rect, aliment: aliment, flag: flag, config: config, completion: completion)
    }

    /// 向下展开
    /// - Parameters:
    ///   - rect: 在目标容器中显示的区域
    ///   - aliment: contentView 与Rect对齐的位置
    ///   - flag: 是否动画
    func popDown(to rect: CGRect, aliment: PopAlignment, flag: Bool, config: ModalConfig = .init(), completion: ModalAnimation.Completion? = nil) {
        let anchorPoint: CGPoint
        let position: CGPoint
        switch aliment {
        case .leading:
            position = CGPoint(x: rect.minX, y: rect.maxY)
            anchorPoint = CGPoint(x: 0.0, y: 0.0)
        case .middle:
            position = CGPoint(x: rect.midX, y: rect.maxY)
            anchorPoint = CGPoint(x: 0.5, y: 0.0)
        case .trailing:
            position = CGPoint(x: rect.maxX, y: rect.maxY)
            anchorPoint = CGPoint(x: 1.0, y: 0.0)
        }
        let states = StyleConfig(.popup(position, anchorPoint, .down))
        states.animator.animationEnable = flag
        present(config, states: states, completion: completion)
    }
}
