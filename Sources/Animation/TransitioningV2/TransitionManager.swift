//
//  TransitionManager.swift
//  Pods
//
//  Created by WQ on 2019/9/2.
//  swiftlint:disable line_length

import Foundation

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

public enum TransitionStyle {
//    case none //使用系统自带的 动画方式
    case auto // 没有动画不做任何处理
    /// 自定义push动画
    case push
    /// 使用自定义的 转场动画
    case customModal
    /// 直接添加到父控制器上
    case child
    /// 创建新窗口并且成为新窗口的根控制器
    case newWindowRoot
}
public enum TransitionPanDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}
open class TransitionManager: NSObject {
    public typealias Completion = ((Bool) -> Void)
//    public weak var delegate: TransitionManagerDelegate?
    /// 动画前将要进行的动作
    public internal(set) var isShow: Bool = true
    /// 是否需要管理VC的生命周期
    public var shouldViewControllerLifeCycle: Bool = false
    /// 是否正在交互
    public var isInteractive: Bool = false
    
    /// 动画时长
    public var duration: TimeInterval = 0.25
    
    weak var showFromViewController: UIViewController?
    
    public internal(set) var containerWindow: WQTransitionWindow?
    
    var transitionStyle: TransitionStyle = .auto
    public unowned let showViewController: UIViewController
    
    public var context: TransitionAnimateContext?
    public let preprocessor: TransitionAnimationPreprocessor
    
    var width: CGFloat = .nan
    
    public init(_ viewController: UIViewController, preprocessor: TransitionAnimationPreprocessor) {
        self.showViewController = viewController
        self.preprocessor = preprocessor
        super.init()
    }
    
    /// 默认为View的宽度
    public func setPanGesture(_ pan: UIPanGestureRecognizer, direction: DrivenDirection, moveWidth: CGFloat? = nil) {
        pan.addTarget(self, action: #selector(handlePanGesture(_:)))
    } 
}
public extension TransitionManager {
    @objc
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        if width == .nan {
            width = view.frame.width //待确认
        }
        switch sender.state {
        case .began:
            sender.setTranslation(.zero, in: view)
            if !isShow {
                switch self.transitionStyle {
                case .customModal:
                     self.showViewController.dismiss(animated: true, completion: nil)
                default:
                    if #available(iOS 11.0, *) {
                        let propertyContext = TransitionPropertyContext()
                        propertyContext.animator.addAnimations { [weak self] in
                            guard let `self` = self else { return }
                        
                            self.preprocessor.preprocessor(willTransition: self, completion: { flag in
                                
                            })
                            
                        }
                    }
                }
            } 
        case .changed:
            self.context?.transitionUpdate(0.1)
        case .ended:
            self.context?.transitionFinish()
        default:
            self.context?.transitionCancel()
        }
    }
    
//    func prepareAnimate() {
//        switch self.transitionStyle {
//        case .customModal:
//
//        default:
//            <#code#>
//        }
//    }
//    func handleAnimateCompletion(_ isSuccess: Bool) {
//        switch self.transitionStyle {
//        case .customModal:
//            if self
//        default:
//            break
//        }
//    }
}
