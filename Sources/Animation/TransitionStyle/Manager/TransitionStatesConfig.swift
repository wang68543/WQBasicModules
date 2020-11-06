//
//  TransitionStatesConfig.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/30.
//

import Foundation


/// 转场动画各种状态的配置
public class TransitionStatesConfig {
    /// 各个状态的配置
    public private(set) var states: [ModalState: WQReferenceStates]
    /// 是否需要遮罩
    public var dimming: Bool = false
   /// states
    public let showStyle: TransitionShowStyle
    /// 动画方式 ModalDefaultAnimation
    public let animationStyle: TransitionAnimationStyle
     
    /// 动画之前附加的view
    public var snapShotAttachAnimatorViews: [ModalState: [UIView: [UIView]]] = [:]
    
    /// 动画执行者
    lazy var animator: TransitionAnimation = {
        return animationStyle.animator
    }()
    public init(_ style: TransitionShowStyle, anmation: TransitionAnimationStyle) {
        self.showStyle = style
        self.animationStyle = anmation
        switch style {
        case let .custom(values):
            states = values
        default:
            states = [:]
            break
        }
    } 
}
public extension TransitionStatesConfig {
    func addState(_ target: AnyHashable, values: [TSReferenceWriteable], state: ModalState) {
        var states = self.states[state]?[target] ?? []
        states.append(contentsOf: values)
        self.states[state]?[target] = states
    }
    
    func addState(_ target: AnyHashable, value: TSReferenceWriteable, state: ModalState) {
        self.addState(target, values: [value], state: state)
    }
}   

