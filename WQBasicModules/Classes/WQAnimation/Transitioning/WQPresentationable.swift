//
//  WQAlertController.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/12.
//
import UIKit

/// 专职于显示Alert的Window
class WQPresentationWindow: UIWindow {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    deinit {
        debugPrint("弹窗窗口销毁了")
    }
}

public let WQContainerWindowLevel: UIWindow.Level = .alert - 4.0

public protocol DrivenableProtocol: NSObjectProtocol {
    var isInteractive: Bool { get set }
    var completionWidth: CGFloat { get set }
    var panGesture: UIPanGestureRecognizer { get set }
    var shouldCompletionSpeed: CGFloat { get set }
    var shouldCompletionProgress: CGFloat { get set }
    var direction: DrivenDirection { get set }
    
    func isEnableDriven(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    func shouldCompletionInteraction(_ velocity: CGPoint, translate: CGPoint ) -> Bool
}
public typealias Drivenable = NSObject & UIViewControllerInteractiveTransitioning & DrivenableProtocol
open class WQPresentationable: UIViewController {
    public let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    public let animator: WQTransitioningAnimator
    // 显示的时候的交互动画 暂时只支持present动画
    public var showInteractive: Drivenable?
    public var hidenDriven: Drivenable?
    /// 滑动交互消失的方向
    public var interactionDissmissDirection: DrivenDirection? {
        didSet {
            if #available(iOS 10.0, *) {
                if let direction = interactionDissmissDirection {
                    let panGR = UIPanGestureRecognizer()
                    let driven = WQPropertyDriven(panGR, items: self.animator.items, direction: direction, isShow: false)
                    self.view.addGestureRecognizer(panGR)
                    panGR.addTarget(self, action: #selector(handleDismissPanGesture(_:)))
                    panGR.delegate = self
                    self.hidenDriven = driven
                } else {
                    self.hidenDriven = nil
                }
            } else {
                if let direction = interactionDissmissDirection {
                    let panGR = UIPanGestureRecognizer()
                    let driven = WQTransitionDriven(gesture: panGR, direction: direction)
                    self.view.addGestureRecognizer(panGR)
                    panGR.addTarget(self, action: #selector(handleDismissPanGesture(_:)))
                    panGR.delegate = self
                    self.hidenDriven = driven
                } else {
                    self.hidenDriven = nil
                }
            }
        }
    }
    /// 是否支持点击背景消失
    open var isEnableTabBackgroundDismiss: Bool = false {
        didSet {
            if isEnableTabBackgroundDismiss {
                self.addTapGesture()
            } else {
                self.removeTapGesture()
            }
        }
    }
    /// 是否开启键盘输入框监听 (用于自动上移输入框遮挡)
    open var isEnableKeyboardObserver: Bool = false {
        didSet {
            if isEnableKeyboardObserver {
                self.addKeyboardObserver()
            } else {
                self.removeKeyboardObserver()
            }
        }
    }
    /// 是否是Modal出来的
    public internal(set) var shownMode: WQShownMode = .present 
    ///containerView上的子View 用于转场动画切换
    public internal(set) var childViews: [UIView] = []
    /// 主要用于搜索containerView上当前正在显示的View包含的输入框
    internal var contentViewInputs: [UITextInput] = []
    private var tapGesture: UITapGestureRecognizer?
    
    /// shownInWindow的时候 记录的属性 用于消失之后恢复
    private weak var previousKeyWindow: UIWindow?
    //用于容纳当前控制器的window窗口
    private var containerWindow: WQPresentationWindow?
    
    /// addChildController或者windowRootController的时候 用于动画管理器里面的转场动画
    private weak var shouldUsingPresentionAnimatedController: UIViewController?
 
    public init(subView: UIView, animator: WQTransitioningAnimator) {
        self.animator = animator
        super.init(nibName: nil, bundle: nil)
        self.childViews.append(subView)
        self.addContainerSubview(subView)
    } 
    override open func viewDidLoad() {
        super.viewDidLoad()
        //延迟加载View
         self.animator.items.initial(nil, presenting: self)
         self.view.addSubview(containerView)
         containerView.layoutIfNeeded()
    }
    open func show(animated flag: Bool, in controller: UIViewController? = nil, completion: (() -> Void)? = nil) {
        let presnetVC: UIViewController? = controller ?? WQUIHelp.topVisibleViewController()
        if presnetVC?.presentedViewController != nil {
            self.shownInParent(presnetVC!, flag: flag, completion: completion)
        } else if let topVC = presnetVC {
            //TODOs:这里不管显示那个控制器 最后都是有当前window的根控制器来控制显示 转场的动画也是根控制器参与动画
            self.presentSelf(in: topVC, flag: flag, completion: completion)
        } else {
            self.shownInWindow(flag, completion: completion)
        }
    }
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        switch shownMode {
        case .childController:
            hideFromParent(animated: flag, completion: completion)
        case .present:
            super.dismiss(animated: flag, completion: completion)
        case .windowRootController:
            hideFromWindow(animated: flag, completion: completion)
        }
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isEnableKeyboardObserver {
           self.addKeyboardObserver()
        }
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isEnableKeyboardObserver {
            self.removeKeyboardObserver()
        }
    }
   
    deinit {
        //手动置空关联值 防止坏内存引用
        childViews.forEach { $0.presentation = nil }
        self.containerWindow = nil
        debugPrint("控制器销毁了")
    }
    @available(*, unavailable, message: "loading this view from nib not supported" )
    required public init?(coder aDecoder: NSCoder) {
        fatalError("not supported nib")
    }
}

// MARK: - -- 提供给外部使用的接口
extension WQPresentationable {
   public func presentSelf(in controller: UIViewController, flag: Bool, completion: (() -> Void)?) {
        self.shownMode = .present
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        controller.present(self, animated: flag, completion: completion)
    }
   public func shownInParent(_ controller: UIViewController, flag: Bool, completion: (() -> Void)?) {
        self.shownMode = .childController
        var topVC: UIViewController
        var animatedVC: UIViewController?
        //保证使用全屏的View
        // 尽量确保层级是navigationController的子控制器 并动画的是navigationController的子控制器
        var shouldAdvanceLayout: Bool = false
        if let navgationController = controller.navigationController {
            topVC = navgationController
            animatedVC = navgationController.visibleViewController
        } else if let tabBarController = controller.tabBarController {
            shouldAdvanceLayout = true // tabBarController在增加了子控制器之后会刷新布局从而覆盖动画的效果 所以需要在动画之前刷新一遍
            topVC = tabBarController
            animatedVC = tabBarController.selectedViewController ?? controller
        } else {
            topVC = controller.parent ?? controller
            animatedVC = controller.topVisible()
        }
        //这里 controller如果当前是根控制器 则关于presented的frame 动画可能会出现异常
        shouldUsingPresentionAnimatedController = animatedVC
        topVC.addChild(self)
        topVC.view.addSubview(self.view)
        if shouldAdvanceLayout {
            CATransaction.begin()
            CATransaction.disableActions()
            topVC.view.layoutIfNeeded()
            CATransaction.commit()
        }
        if flag {
            self.animator.animated(presented: animatedVC, presenting: self, isShow: true) { [weak self] _ in
                guard let weakSelf = self else {
                    completion?()
                    return
                }
                weakSelf.didMove(toParent: topVC)
                completion?()
            }
        } else {
            self.animator.items.config(animatedVC, presenting: self, isShow: true)
            self.didMove(toParent: topVC)
            completion?()
        }
        if #available(iOS 10.0, *) {
            
        } else {
            interactionDissmissDirection = nil
        }
    
    }
   public func shownInWindow(_ flag: Bool, completion: (() -> Void)?) {
        self.shownMode = .windowRootController
        self.previousKeyWindow = UIApplication.shared.keyWindow
        if self.containerWindow == nil {
            self.containerWindow = WQPresentationWindow(frame: UIScreen.main.bounds)
            self.containerWindow?.windowLevel = WQContainerWindowLevel
            self.containerWindow?.backgroundColor = .clear;// 避免横竖屏旋转时出现黑色
        }
        self.containerWindow?.rootViewController = self
        self.containerWindow?.makeKeyAndVisible()
        let preRootViewController = UIApplication.shared.delegate?.window??.rootViewController
        self.shouldUsingPresentionAnimatedController = preRootViewController
        if flag {
            self.animator.animated(presented: preRootViewController, presenting: self, isShow: true) { _ in
                completion?()
            }
        } else {
            self.animator.items.config(preRootViewController, presenting: self, isShow: true)
            completion?()
        }
        interactionDissmissDirection = nil
    }
    
    private func hideFromParent(animated flag: Bool, completion: (() -> Void)? ) {
        func animateFinshed() {
            self.view.removeFromSuperview()
            self.removeFromParent()
            completion?()
        }
        self.willMove(toParent: nil)
        if !flag {
            self.animator.items.config(self.shouldUsingPresentionAnimatedController,
                                       presenting: self,
                                       isShow: false)
            animateFinshed()
        } else {
            if #available(iOS 10.0, *),
                let driven = self.hidenDriven as? WQPropertyDriven {
                driven.startIneractive(presented: self.shouldUsingPresentionAnimatedController, presenting: self) { position in
                    if position == .end {
                        animateFinshed()
                    }
                }
            } else {
                self.animator.animated(presented: self.shouldUsingPresentionAnimatedController,
                                       presenting: self,
                                       isShow: false) { _ in
                                        animateFinshed()
                }
            }
            
        }
    }
    private func hideFromWindow(animated flag: Bool, completion: (() -> Void)? ) {
        func animateFinshed() {
            if UIApplication.shared.keyWindow === self.containerWindow {
                if let isPreviousHidden = self.previousKeyWindow?.isHidden,
                    isPreviousHidden {
                    UIApplication.shared.delegate?.window??.makeKey()
                } else {
                    self.previousKeyWindow?.makeKey()
                }
            }
            self.containerWindow?.isHidden = true
            self.containerWindow?.rootViewController = nil
            self.previousKeyWindow = nil
            completion?()
        }
        if !flag {
            self.animator.items.config(self.shouldUsingPresentionAnimatedController, presenting: self, isShow: false)
            animateFinshed()
        } else {
            self.animator.animated(presented: self.shouldUsingPresentionAnimatedController, presenting: self, isShow: false) { _ in
                animateFinshed()
            }
        }
    }
}
// MARK: - -- Gesture Handle
extension WQPresentationable {
    @objc
    func handleDismissPanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.hidenDriven?.isInteractive = true
            self.dismiss(animated: true)
        default:
            break
        }
    }
    @objc
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    func addTapGesture() {
        self.removeTapGesture()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGR.delegate = self
        self.view.addGestureRecognizer(tapGR)
        self.tapGesture = tapGR
    }
    func removeTapGesture() {
        guard let tapGR = self.tapGesture else {
            return
        }
        self.view.removeGestureRecognizer(tapGR)
        self.tapGesture = nil
    }
}

// MARK: - -- UIGestureRecognizerDelegate
extension WQPresentationable: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tapGR = gestureRecognizer as? UITapGestureRecognizer,
            tapGR === self.tapGesture {
            let location = tapGR.location(in: self.view)
            if self.containerView.frame.contains(location) {
                return false
            }
        } else if let interactive = self.hidenDriven {
            return interactive.isEnableDriven(gestureRecognizer)
        }
        return true
    }
}
