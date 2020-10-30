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
    public typealias Completion = ((Bool) -> Void)
    public internal(set) var state: ModalState = .readyToShow
    
    public var states: [ModalState: WQReferenceStates] = [:]
    /// 当前状态的时候将[UIView]添加到UIView上
    public var snapShotAttachAnimatorViews: [ModalState: [UIView: [UIView]]] = [:]
//    /// 这里的view 咋 readShow的时候 添加到view showing的时候移除 (主要用于开场显示的时候 从一个动画到这个动画)
//    public var snapShotShowViews: [UIView] = []
//    /// showing -> hide的时候 显示
//    public var snapShotHideViews: [UIView] = []
    
//    public weak var delegate: TransitionManagerDelegate?

    /// 动画时长
//    public var duration: TimeInterval = 0.25

    public weak var fromViewController: UIViewController?

//    public internal(set) var transitionStyle: ModalStyle = .autoModal
    public weak var showViewController: WQLayoutController?

    public var context: ModalContext?
    
//    lazy var context: ModalContext = {
//        guard let ctx = ModalContext.modalContext(with: self.showViewController, modalStyle: self.transitionStyle) else {
//            fatalError("请先设置ModalStyle")
//        }
//        return ctx
//    }()
    
//    public weak var animator: TransitionAnimationPreprocessor?

    
    
//    public let preprocessor: TransitionAnimationPreprocessor
    
//    var width: CGFloat = .nan
    
//    public init(_ viewController: WQLayoutController) {
//        self.showViewController = viewController
////        self.preprocessor = preprocessor
//        super.init()
//    }
//    func prepareShow() {
////        UIView.performWithoutAnimation {
////            self.readyShowStates.forEach { (instance, values) in
////                values.forEach { value in
////                    value.setup(instance, state: .readyToShow)
////                }
////            }
////        }
//    }
    func show(_ context: ModalContext, animation: TransitionAnimationPreprocessor) {
        
    }
    
    func hide(_ context: ModalContext, animation: TransitionAnimationPreprocessor) {
        
    }
}
public extension TransitionManager {
    
}
