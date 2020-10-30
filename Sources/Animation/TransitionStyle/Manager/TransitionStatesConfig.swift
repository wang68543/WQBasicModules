//
//  TransitionStatesConfig.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/30.
//

import Foundation

public typealias WQReferenceStates = [AnyHashable: [TSReferenceWriteable]]
/// 转场动画各种状态的配置
public class TransitionStatesConfig {
    /// 各个状态的配置
    public var states: [ModalState: WQReferenceStates] = [:]
    /// 是否需要遮罩
    public var dimming: Bool
    /// 动画之前附加的view
    public var snapShotAttachAnimatorViews: [ModalState: [UIView: [UIView]]] = [:]
    
    init(_ states: [ModalState: WQReferenceStates], isDimming: Bool = false) {
        self.states = states
        self.dimming = isDimming
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
//func addDefaultDimming(_ initial: UIColor = .clear, show: UIColor = UIColor.black.withAlphaComponent(0.6)) {
//    self.stateConfig.dimming = true
//    let keyPath = \WQLayoutController.dimmingView.backgroundColor
//    self.addStateToTarget(TSReferenceColor(value: initial, keyPath: <#T##ReferenceWritableKeyPath<WQLayoutController, UIColor>#>), state: <#T##ModalState#>)
//}
