//
//  TransitionStatesConfig.swift
//  Pods
//
//  Created by WQ on 2020/10/30.
//

import Foundation

/// 转场动画各种状态的配置
@available(iOS 10.0, *)
public class StyleConfig {
    /// 各个状态的配置
    public var states: [ModalState: ModalMapItems]
   /// states
    public let showStyle: ModalShowStyle
    /// 动画方式 ModalDefaultAnimation
    public let animationStyle: ModalAnimationStyle 
    /// 动画之前附加的view
    public var snapShotAttachAnimatorViews: [ModalState: [UIView: [UIView]]] = [:]
    
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
//    deinit {
//        debugPrint("\(self):" + #function + "♻️")
//    }
}
@available(iOS 10.0, *)
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


