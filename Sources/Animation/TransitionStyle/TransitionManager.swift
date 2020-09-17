//
//  TransitionManager.swift
//  Pods
//
//  Created by WQ on 2019/9/2.
//  swiftlint:disable line_length

import Foundation


//public enum 
public protocol TransitionManagerDelegate: NSObjectProtocol {
    func transitionManager(prepare manager: TransitionManager)

    /// from to 始终是相对于
    func transitionManager(willTransition manager: TransitionManager, completion: TransitionManager.Completion)

//    func transitionManager(willHide manager: TransitionManager, completion: TransitionManager.Completion )

    /// 手势交互弹出
    func transitionManager(shouldShowController manager: TransitionManager) -> UIViewController
}

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
public typealias WQReferenceStates = [AnyHashable: [TSReferenceWriteable]]

open class TransitionManager: NSObject {
    public typealias Completion = ((Bool) -> Void)
    
    public var readyShowStates: WQReferenceStates = [:]
    public var showingStates: WQReferenceStates = [:]
    public var dismissStates: WQReferenceStates = [:]
    /// 这里的view 咋 readShow的时候 添加到view showing的时候移除 (主要用于开场显示的时候 从一个动画到这个动画)
    public var snapShotShowViews: [UIView] = []
    /// showing -> hide的时候 显示
    public var snapShotHideViews: [UIView] = []
    
    public weak var delegate: TransitionManagerDelegate?

    /// 动画时长
    public var duration: TimeInterval = 0.25

    public weak var fromViewController: UIViewController?

//    public internal(set) var containerWindow: WQTransitionWindow?

    var transitionStyle: ModalStyle = .autoModal
    public unowned let showViewController: WQLayoutController

//    public var context: ModalContext?
    lazy var context: ModalContext = {
        guard let ctx = ModalContext.modalContext(with: self.showViewController, modalStyle: self.transitionStyle) else {
            fatalError("请先设置ModalStyle")
        }
        return ctx
    }()
//    public let preprocessor: TransitionAnimationPreprocessor
    
//    var width: CGFloat = .nan
    
    public init(_ viewController: WQLayoutController) {
        self.showViewController = viewController
//        self.preprocessor = preprocessor
        super.init()
    }
    func show() {
        self.transitionStyle = .modalSystem
        
//        context.show(in: <#T##UIViewController?#>, animated: <#T##Bool#>)
//        context?.show(in: fromViewController, animated: <#T##Bool#>, completion: <#T##ModalContext.Completion?##ModalContext.Completion?##() -> Void#>)
    }
    func alert(with width: CGFloat, height: CGFloat) {
        
    }
    func sheet(with width: CGFloat, height: CGFloat, shouldMarginBottom: Bool) {
        
    }
    /// 默认为View的宽度
//    public func setPanGesture(_ pan: UIPanGestureRecognizer, direction: DrivenDirection, moveWidth: CGFloat? = nil) {
////        pan.addTarget(self, action: #selector(handlePanGesture(_:)))
//    } 
}
public extension TransitionManager {
//    @objc
//    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
//        guard let view = sender.view else {
//            return
//        }
//        if width == .nan {
//            width = view.frame.width //待确认
//        }
//        switch sender.state {
//        case .began:
//            sender.setTranslation(.zero, in: view)
//            if !isShow {
//                switch self.transitionStyle {
//                case .customModal:
//                     self.showViewController.dismiss(animated: true, completion: nil)
//                default:
//                    if #available(iOS 11.0, *) {
//                        let propertyContext = TransitionPropertyContext()
//                        propertyContext.animator.addAnimations { [weak self] in
//                            guard let `self` = self else { return }
//
//                            self.preprocessor.preprocessor(willTransition: self, completion: { flag in
//
//                            })
//
//                        }
//                    }
//                }
//            }
//        case .changed:
//            self.context?.transitionUpdate(0.1)
//        case .ended:
//            self.context?.transitionFinish()
//        default:
//            self.context?.transitionCancel()
//        }
//    }
    
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
