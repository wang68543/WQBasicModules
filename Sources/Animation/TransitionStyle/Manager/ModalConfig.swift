//
//  ModalConfig.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/10/30.
//  转场动画所需环境的参数

import Foundation

public enum InteractDismissMode {
    public enum Direction {
        case toTop
        case toBottom
        case toLeft
        case toRight
    }
    case none
    /// 点击容器以外的背景消失
    case tapOutSide
    /// 点击所有的背景都消失
    case tapAll
    /// 移动消失
    case pan(Direction)
}
public class ModalConfig {
    let style: ModalStyle
    /// 显示ViewController
    weak var fromViewController: UIViewController?
    /// 容器控制器
    let presenting = WQLayoutController()
    /// 是否要调用生命周期
    let layoutControllerLifeCycleable: Bool = false
    /// 用户交互消失的方式
    var interactionDismiss: InteractDismissMode = .none
    /// 容器控制器的View显示frame
    var containerViewControllerFinalFrame: CGRect = UIScreen.main.bounds
    

//    let stateConfig: TransitionStatesConfig
    
    init(_ style: ModalStyle = .autoModal, fromViewController: UIViewController?) {
        self.style = style
//        self.stateConfig = states
        self.fromViewController = fromViewController
    }
}
//public extension ModalConfig {
//    /// 添加属性到fromViewController
//    func addStateFromTarget(_ values: [TSReferenceWriteable], state: ModalState) {
//        guard let from = self.fromViewController else { return }
//        self.stateConfig.addState(from, values: values, state: state)
//    }
//    /// 添加属性到fromViewController
//    func addStateFromTarget(_ value: TSReferenceWriteable, state: ModalState) {
//        self.addStateFromTarget([value], state: state)
//    }
//    /// 添加属性到presenting
//    func addStateToTarget(_ values: [TSReferenceWriteable], state: ModalState) {
////        addState(presenting, values: values, state: state)
//    }
//    /// 添加属性到presenting
//    func addStateToTarget(_ value: TSReferenceWriteable, state: ModalState) {
//        self.addStateToTarget([value], state: state)
//    }
//
//
//}
