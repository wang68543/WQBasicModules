//
//  TransitionStatesConfig.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/30.
//

import Foundation


/// 转场动画各种状态的配置
public class StyleConfig {
    /// 各个状态的配置
    public var states: [ModalState: ModalMapItems]
    /// 是否需要遮罩
    public var dimming: Bool = true
   /// states
    public let showStyle: ModalShowStyle
    /// 动画方式 ModalDefaultAnimation
    public let animationStyle: ModalAnimationStyle 
    /// 动画之前附加的view
    public var snapShotAttachAnimatorViews: [ModalState: [UIView: [UIView]]] = [:]
    
    /// 约束container的显示尺寸(主要适用于actionSheet,alert)
    public var constraintSize = CGSize.zero
    /// 动画执行者
    lazy var animator: ModalAnimation = {
        return animationStyle.animator
    }()
    
    public init(_ style: ModalShowStyle, anmation: ModalAnimationStyle = .default) {
        self.showStyle = style
        self.animationStyle = anmation
        var sts: [ModalState: ModalMapItems]
        
        switch style {
        case let .custom(values):
            sts = values
        default:
            sts = [:]
            break
        } 
        states = sts
    }
    deinit {
        debugPrint("\(self):" + #function + "♻️")
    }
}
public extension StyleConfig {
    func addState(_ target: NSObject, values: [ModalKeyPath], state: ModalState) {
        var sts = self.states[state] ?? []
        sts.addState(target, values)
        self.states[state] = sts
    }
    
    func addState(_ target: NSObject, value: ModalKeyPath, state: ModalState) {
        self.addState(target, values: [value], state: state)
    }
}   
public extension StyleConfig {
    func setupStates(_ layout: WQLayoutController, config: ModalConfig) {
        var values: [ModalState: ModalMapItems] = [:]
        var size = self.constraintSize
        if size == .zero { size = layout.container.sizeThatFits() }
        let controllerSize = config.showControllerFrame.size
        switch self.showStyle {
            case .alert:
                let diming = self.dimingReference()
                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: (controllerSize.height - size.height)*0.5, width: size.width, height: size.height)
                let willShowFrame = ModalRect(container: containerFrame)
                let tranforms = self.alertTransform()
                var references: [ModalState: [ModalKeyPath]] = [:]
                references.combine([.willShow: willShowFrame])
                references.combine(diming)
                references.combine(tranforms)
                for (key, items) in references {
                    values[key] = [ModalMapItem(layout, refrences: items)]
                }
            case .actionSheet:
                let diming = self.dimingReference()
                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: controllerSize.height - size.height, width: size.width, height: size.height)
                let willShowFrame = ModalRect(container: containerFrame)
                let tranforms = self.actionSheetTransform(size, container: controllerSize)
                var references: [ModalState: [ModalKeyPath]] = [:]
                references.combine([.willShow: willShowFrame])
                references.combine(diming)
                references.combine(tranforms)
                for (key, items) in references {
                    values[key] = [ModalMapItem(layout, refrences: items)]
                }
        case let .pan(positions):
           if let willShowPostion = positions[.willShow],
            let showPostion = positions[.show],
            let hidePosition = positions[.hide] {
            let containerFrame = showPostion.frame(size: size, container: controllerSize, state: .show)
            let willShowPoint = willShowPostion.center(size: size, container: controllerSize, state: .willShow)
            let showPoint = showPostion.center(size: size, container: controllerSize, state: .show)
            let hidePoint = hidePosition.center(size: size, container: controllerSize, state: .hide)
            let diming = self.dimingReference()
            let willShowFrame = ModalRect(container: containerFrame)
            let tranforms = self.panTransform(willShowPoint, show: showPoint, hide: hidePoint)
            var references: [ModalState: [ModalKeyPath]] = [:]
            references.combine([.willShow: willShowFrame])
            references.combine(diming)
            references.combine(tranforms)
            for (key, items) in references {
                values[key] = [ModalMapItem(layout, refrences: items)]
            }
           }
            default:
                break
            }
        self.states.merge(values, uniquingKeysWith: {(_, new) in new })
    }
    
   private func dimingReference() -> [ModalState: ModalKeyPath] {
        var values: [ModalState: ModalKeyPath] = [:]
        if self.dimming {
            values[.willShow] = ModalFloat(dimming: 0.0)
            values[.show] = ModalFloat(dimming: 1.0)
            values[.hide] = values[.willShow]
        }
        return values
    }
    
    private func alertTransform() -> [ModalState: ModalKeyPath] {
        let initalValue = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let showValue = CGAffineTransform(scaleX: 1.05, y: 1.05)
        let didShowValue = CGAffineTransform.identity
        let hideValue = CGAffineTransform(scaleX: 0.4, y: 0.4)
        var values: [ModalState: ModalKeyPath] = [:]
        values[.willShow] = ModalTransform(container: initalValue)
        values[.show] = ModalTransform(container: showValue)
        values[.didShow] = ModalTransform(container: didShowValue)
        values[.hide] = ModalTransform(container: hideValue)
        return values
    }
    private func actionSheetTransform(_ size: CGSize, container: CGSize) -> [ModalState: ModalKeyPath] {
        let inital = CGPoint(x: 0, y: container.height + size.height*0.5)
        let show = CGPoint(x: 0, y: container.height - size.height*0.5)
        let hide = inital
        return panTransform(inital, show: show, hide: hide)
    }
    private func panTransform(_ initial: CGPoint, show: CGPoint, hide: CGPoint) -> [ModalState: ModalKeyPath] {
        let initalValue = CGAffineTransform(translationX: initial.x - show.x, y: initial.y - show.y)
        let showValue = CGAffineTransform(translationX: -min((initial.x - show.x) * 0.05, 15), y: -min((initial.y - show.y) * 0.05, 15))
        let didShowValue = CGAffineTransform.identity
        let hideValue = CGAffineTransform(translationX: hide.x - show.x, y: hide.y - show.y)
        var values: [ModalState: ModalKeyPath] = [:]
        values[.willShow] = ModalTransform(container: initalValue)
        values[.show] = ModalTransform(container: showValue)
        values[.didShow] = ModalTransform(container: didShowValue)
        values[.hide] = ModalTransform(container: hideValue)
        return values
    }
}
