//
//  ModalContext.swift
//  Pods
//
//  Created by WQ on 2020/8/21.
//
import UIKit
//https://blog.devtang.com/2016/03/13/iOS-transition-guide/
@available(iOS 10.0, *)
open class ModalContext: NSObject, WQLayoutControllerTransition {
    
    public let animator: ModalAnimation
    
    public unowned let config: ModalConfig
    
    public private(set) var styleConfig: StyleConfig
    
    /// 当前是否正在交互
    public private(set) var isInteractive: Bool = false {
        didSet {
            self.animator.isInteractive = isInteractive
        }
    }
    
    /// 当前是否正在弹窗
    internal private(set) var isShow: Bool = false
    
    /// 用于记录当前
    internal weak var navgationController: UINavigationController?
    /// 记录交互时候的controller
    internal weak var interactViewController: UIViewController?
    
    public init(_ config: ModalConfig, states: StyleConfig) {
        self.config = config
        self.styleConfig = states
        animator = states.animator
        super.init()
    }
    
    /// 是否使用默认时间
    private var isDefaultDuration: Bool = false
    // 动画的时间
    var animateDuration: TimeInterval {
        if self.animator.duration == .zero {
            isDefaultDuration = true
        }
        if isDefaultDuration {
            if self.isShow {
                if self.styleConfig.states.has(key: .didShow) {
                    return 0.45
                } else {
                    return 0.25
                }
            } else {
                return 0.25
            }
        } else {
            return self.animator.duration
        }
    }
    
    public func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: (() -> Void)?) {
        self.isShow = true
        self.isInteractive = false
        self.styleConfig = statesConfig
        self.animator.duration = self.animateDuration
    }
//    @discardableResult
    public func hide(_ controller: WQLayoutController, animated flag: Bool, completion: (() -> Void)?) {//-> Bool
        self.isShow = false
        self.isInteractive = false
        self.animator.animationEnable = flag
        self.animator.duration = self.animateDuration
//        return true
    }
    
    
    public func interactive(dismiss controller: WQLayoutController) {
        self.isInteractive = true
        self.isShow = false
        self.animator.duration = self.animateDuration
        self.animator.animationEnable = true
    }
    
    public func interactive(present controller: WQLayoutController, statesConfig states: StyleConfig) {
        self.isInteractive = true
        self.isShow = true
        self.styleConfig = states
        self.animator.duration = self.animateDuration
        self.animator.animationEnable = true
    }
    public func interactive(update progress: CGFloat) {
//        debugPrint("###########\(progress)")
    }
    public func interactive(finish velocity: CGPoint) {
        self.isInteractive = false
    }
    public func interactive(cancel velocity: CGPoint) { 
        self.isInteractive = false
    }
    deinit {
       debugPrint("\(self):" + #function + "♻️")
    }
}

@available(iOS 10.0, *)
public extension ModalContext {
    func navgationController(_ controller: WQLayoutController) -> UINavigationController { 
        guard self.navgationController == nil else {
            return self.navgationController!
        }
        let nav = self.config.navgationControllerType.init(rootViewController: controller)
        nav.setNavigationBarHidden(true, animated: false)
        self.navgationController = nav
        return nav
    }
    
    func viewController(_ controller: WQLayoutController) -> UIViewController {
        if let interact = self.interactViewController { //记录的返回
            return interact
        } else if self.config.isShowWithNavigationController {
           let nav = self.navgationController(controller)
            self.interactViewController = nav
           return nav
        } else {
            self.interactViewController = controller
            return controller
        }
    }
    
    var layoutViewController: WQLayoutController? {
        if self.interactViewController is WQLayoutController {
            return self.interactViewController as? WQLayoutController
        } else if let nav = self.interactViewController as? UINavigationController {
            return nav.topViewController as? WQLayoutController
        }
        return nil
    }
}


/// 主要用于驱动动画 含驱动管理
@available(iOS 10.0, *)
open class ModalDrivenContext: ModalContext {
    
    var interactiveAnimator: UIViewPropertyAnimator?
     
    public override func interactive(update progress: CGFloat) {
        super.interactive(update: progress)
        guard let animator = self.interactiveAnimator else { return }
        guard !animator.isRunning else { return }
        animator.fractionComplete = progress
    } 
    
    func continueAnimation(_ velocity: CGPoint) {
        let provider = UISpringTimingParameters.completion(velocity)
        self.interactiveAnimator?.continueAnimation(withTimingParameters: provider, durationFactor: 1.0)
    }
}
@available(iOS 10.0, *)
extension UISpringTimingParameters {
    static func completion(_ velocity: CGPoint) -> UITimingCurveProvider {
        let velocityVector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
        return UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: velocityVector)
    }
}
 
/// 构造不同的动画场景
@available(iOS 10.0, *)
public extension ModalContext {
    static func modalContext(_ config: ModalConfig, states: StyleConfig) -> ModalContext? {
        let fixStyle: ModalPresentation
        if config.style == .autoModal {
            fixStyle = config.style.autoAdaptationStyle
        } else {
            fixStyle = config.style
        }
        switch fixStyle {
        case .modalSystem:
            return ModalPresentationContext(config, states: states)
        case .modalInParent:
            return ModalInParentContext(config, states: states)
        case .modalInWindow:
            return ModalInWindowContext(config, states: states)
        case .modalNavigation:
            return ModalNavigationContext(config, states: states) 
        default:
            return nil
        }
    }
}
