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
 
    public unowned let config: ModalConfig
    
    public unowned let statesConfig: TransitionStatesConfig
    
    public unowned let showViewController: WQLayoutController
    
    public var context: ModalContext?
    
    public init(_ layout: WQLayoutController) {
        self.config = layout.config
        self.statesConfig = layout.statesConfig
        self.showViewController = layout
//        layout.delegate = self
        super.init()
    }
    
    func show(_ context: ModalContext, animation: TransitionAnimation) {
        
    }
    
    func hide(_ context: ModalContext, animation: TransitionAnimation) {
        
    }
}
public extension TransitionManager {
    
}
