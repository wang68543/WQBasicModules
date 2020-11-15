//
//  TransitionManager.swift
//  Pods
//
//  Created by WQ on 2019/9/2.
//  swiftlint:disable line_length

import Foundation


//public enum 
//public protocol TransitionManagerDelegate: NSObjectProtocol {
//    func transitionManager(prepare manager: TransitionManager)
//
//    /// from to 始终是相对于
//    func transitionManager(willTransition manager: TransitionManager, completion: TransitionManager.Completion)
//
////    func transitionManager(willHide manager: TransitionManager, completion: TransitionManager.Completion )
//
//    /// 手势交互弹出
//    func transitionManager(shouldShowController manager: TransitionManager) -> UIViewController
//}

//public enum TransitionStyle {
////    case none //使用系统自带的 动画方式
//    case auto // 没有动画不做任何处理
//    /// 自定义push动画
//    case push
//    /// 使用自定义的 转场动画
//    case customModal
//    /// 直接添加到父控制器上
//    case child
//    /// 创建新窗口并且成为新窗口的根控制器
//    case newWindowRoot
//}
//public enum TransitionPanDirection {
//    case leftToRight
//    case rightToLeft
//    case topToBottom
//    case bottomToTop
//}


open class TransitionManager: NSObject {
 
    public let config: ModalConfig
    
    public let statesConfig: StyleConfig
    
    public unowned let showViewController: WQLayoutController
    
//    public var context: ModalContext?
    public lazy var context: ModalContext? = {
        return ModalContext.modalContext(config, states: statesConfig )
    }()
    
    public init(_ config: ModalConfig, states: StyleConfig, layout: WQLayoutController) {
        self.config = config
        self.statesConfig = states
        self.showViewController = layout
        super.init()
    }
}
//// custom 配置
//public extension TransitionManager {
//    /// 添加属性到fromViewController
//    func addStateFromTarget(_ values: [ModalKeyPath], state: ModalState) {
//        guard let from = self.config.fromViewController else { return }
//        self.statesConfig.addState(from, values: values, state: state)
//    }
//    /// 添加属性到fromViewController
//    func addStateFromTarget(_ value: ModalKeyPath, state: ModalState) {
//        self.addStateFromTarget([value], state: state)
//    }
//    /// 添加属性到presenting
//    func addStateToTarget(_ values: [ModalKeyPath], state: ModalState) {
//        self.statesConfig.addState(showViewController, values: values, state: state)
//    }
//    /// 添加属性到presenting
//    func addStateToTarget(_ value: ModalKeyPath, state: ModalState) {
//        self.addStateToTarget([value], state: state)
//    }
//
//
//}
