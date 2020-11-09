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
    public var states: [ModalState: WQReferenceStates]
    /// 是否需要遮罩
    public var dimming: Bool = false
   /// states
    public let showStyle: TransitionShowStyle
    /// 动画方式 ModalDefaultAnimation
    public let animationStyle: TransitionAnimationStyle 
    /// 动画之前附加的view
    public var snapShotAttachAnimatorViews: [ModalState: [UIView: [UIView]]] = [:]
    
    /// 约束container的显示尺寸(主要适用于actionSheet,alert)
    public var constraintSize = CGSize.zero
    /// 动画执行者
    lazy var animator: TransitionAnimation = {
        return animationStyle.animator
    }()
    
    public init(_ style: TransitionShowStyle, anmation: TransitionAnimationStyle) {
        self.showStyle = style
        self.animationStyle = anmation
        var sts: [ModalState: WQReferenceStates]
        switch style {
        case let .custom(values):
            sts = values
        default:
            sts = [:]
            break
        }
//        // 需要手动配满各个键值对的值
//        for state in ModalState.allCases {
//            if !sts.has(key: state) {
//                sts[state] = []
//            }
//        }
        states = sts
    }
    deinit {
        debugPrint("\(self):" + #function + "♻️")
    }
}
public extension StyleConfig {
    func addState(_ target: NSObject, values: [TSReferenceWriteable], state: ModalState) {
        var sts = self.states[state] ?? []
        sts.addState(target, values)
        self.states[state] = sts
    }
    
    func addState(_ target: NSObject, value: TSReferenceWriteable, state: ModalState) {
        self.addState(target, values: [value], state: state)
    }
}   
public extension StyleConfig {
    func setupStates(_ layout: WQLayoutController, config: ModalConfig) {
        var values: [ModalState: WQReferenceStates] = [:]
        switch self.showStyle {
            case .alert:
                var willShowStates: WQReferenceStates = []
                let dimWillShowalpha = TSReferenceValue(value: 0.0, keyPath: \WQLayoutController.dimmingView.alpha)
                let containerWillShowalpha = TSReferenceValue(value: 0.0, keyPath: \WQLayoutController.container.alpha)
                
                let controllerSize = config.showControllerFrame.size
                let size = layout.container.sizeThatFits()
                
                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: (controllerSize.height - size.height)*0.5, width: size.width, height: size.height)
                let willShowTransform = TSReferenceTransform(value: CGAffineTransform(scaleX: 0.3, y: 0.3), keyPath: \WQLayoutController.container.transform)
                let willShowFrame = TSReferenceRect(value: containerFrame, keyPath: \WQLayoutController.container.frame)
                willShowStates.addState(layout, [dimWillShowalpha, containerWillShowalpha,willShowFrame,
                                                 willShowTransform])
  
                let showDimalpha = TSReferenceValue(value: 1.0, keyPath: \WQLayoutController.dimmingView.alpha)
                let showConataineralpha = TSReferenceValue(value: 1.0, keyPath: \WQLayoutController.container.alpha)
                let showRefrenceTransform = TSReferenceTransform(value: CGAffineTransform(scaleX: 1.05, y: 1.05), keyPath: \WQLayoutController.container.transform)
                var showStates: WQReferenceStates = []
                showStates.addState(layout, [showDimalpha, showConataineralpha,showRefrenceTransform])
                 
                let didShowRefrenceTransform = TSReferenceTransform(value: .identity, keyPath: \WQLayoutController.container.transform)
                var didShowStates: WQReferenceStates = []
                didShowStates.addState(layout, [didShowRefrenceTransform])
                
                
                var hideStates: WQReferenceStates = []
                let hideTransform = TSReferenceTransform(value: CGAffineTransform(scaleX: 0.6, y: 0.6), keyPath: \WQLayoutController.container.transform)
                hideStates.addState(layout, [hideTransform, dimWillShowalpha, containerWillShowalpha])
                
                values[.willShow] = willShowStates
                values[.show] = showStates
                values[.didShow] = didShowStates
                values[.hide] = hideStates
            case .actionSheet:
                var willShowStates: WQReferenceStates = []
                let dimWillShowalpha = TSReferenceValue(value: 0.0, keyPath: \WQLayoutController.dimmingView.alpha)
                let containerWillShowalpha = TSReferenceValue(value: 0.0, keyPath: \WQLayoutController.container.alpha)
                
                let controllerSize = config.showControllerFrame.size
                let size = layout.container.sizeThatFits()
                
                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: controllerSize.height - size.height, width: size.width, height: size.height)
                let willShowTransform = TSReferenceTransform(value: CGAffineTransform(translationX: 0, y: size.height), keyPath: \WQLayoutController.container.transform)
                let willShowFrame = TSReferenceRect(value: containerFrame, keyPath: \WQLayoutController.container.frame)
                //这里设置transform 必须在设置frame之后 否则identity将会对应为 先设置的transform(离屏的frame)
                willShowStates.addState(layout, [dimWillShowalpha, containerWillShowalpha,willShowFrame,
                                                 willShowTransform ])
  
                let showDimalpha = TSReferenceValue(value: 1.0, keyPath: \WQLayoutController.dimmingView.alpha)
                let showConataineralpha = TSReferenceValue(value: 1.0, keyPath: \WQLayoutController.container.alpha)
                let showRefrenceTransform = TSReferenceTransform(value: CGAffineTransform(translationX: 0, y: -10), keyPath: \WQLayoutController.container.transform)
                var showStates: WQReferenceStates = []
                showStates.addState(layout, [showDimalpha, showConataineralpha,showRefrenceTransform])
                 
                let didShowRefrenceTransform = TSReferenceTransform(value: .identity, keyPath: \WQLayoutController.container.transform)
                var didShowStates: WQReferenceStates = []
                didShowStates.addState(layout, [didShowRefrenceTransform])
                
                
                var hideStates: WQReferenceStates = []
                let hideTransform = TSReferenceTransform(value: CGAffineTransform(translationX: 0, y: size.height), keyPath: \WQLayoutController.container.transform)
                hideStates.addState(layout, [hideTransform, dimWillShowalpha, containerWillShowalpha])
                
                values[.willShow] = willShowStates
                values[.show] = showStates
                values[.didShow] = didShowStates
                values[.hide] = hideStates
            default:
                break
            }
        self.states.merge(values, uniquingKeysWith: {(_, new) in new })
    }
}
