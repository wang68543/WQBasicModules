//
//  WQAlertController.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/12.
//
import UIKit
internal let WQContainerWindowLevel: UIWindow.Level = .alert - 4.0

public class WQVectorView: UIView {
    /// center 与 point 布局解决transform属性动画问题
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let subView = self.subviews.first else { return }
        subView.bounds = self.bounds
        let anchorPoint = subView.layer.anchorPoint
        subView.center = CGPoint(x: anchorPoint.x * self.bounds.width, y: anchorPoint.y * self.bounds.height)
    }
}
open class WQTransitionable: UIViewController {
    /// 容器View 所有的View都需要成为当前View的子View
    public let containerView: WQVectorView = {
        let view = WQVectorView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    public let animator: WQTransitionAnimator
    // 显示的时候的交互动画 暂时只支持present动画
    public var showDriven: TransitionContext?
    public var hidenDriven: TransitionContext?
    /// 滑动交互消失的方向
    public var interactionDismissDirection: DrivenDirection? {
        didSet {
           self.configDismissInteractive(for: interactionDismissDirection)
        }
    }
    /// 是否支持点击背景消失
    open var tapDimmingViewDismissable: Bool = false {
        didSet {
            if tapDimmingViewDismissable {
                self.addTapGesture()
            } else {
                self.removeTapGesture()
            }
        }
    }
    /// 是否开启键盘输入框监听 (用于自动上移输入框遮挡)
    open var enableKeyboardObserver: Bool = false {
        didSet {
            if enableKeyboardObserver {
                self.keyboardManager = WQKeyboardManager(self.containerView)
            } else {
                self.keyboardManager = nil
            }
        }
    }
    /// 是否是Modal出来的
    public internal(set) var showMode: WQShowMode = .present
    /// containerView上的子View 用于转场动画切换
    public internal(set) var childViews: [UIView] = []
    /// 主要用于搜索containerView上当前正在显示的View包含的输入框
    internal var contentViewInputs: [TextFieldView] = []
    internal var tapGesture: UITapGestureRecognizer?
    /// 遮挡View (Debug...)
    internal lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    // 用于容纳当前控制器的window窗口
    public internal(set) var containerWindow: WQTransitionWindow?

    /// 非present的时候 用于动画管理器里面的转场动画
    internal weak var usingTransitionAnimatedController: UIViewController?

    /// 是否要对presentedVC 进行生命周期(调用viewWillApperace...)
    public var shouldViewWillApperance: Bool = false

    /// 控制器初始frame
    internal let initialFrame: CGRect
    /// 初始化
    ///
    /// - Parameters:
    ///   - animator: 动画管理者
    ///   - containerFrme: 初始化设置的container的frame
    ///   - presentedFrame: 弹出框的frame
    public init(subView: UIView,
                animator: WQTransitionAnimator,
                containerFrame: CGRect? = nil,
                presentedFrame: CGRect? = nil) {
        self.animator = animator
        initialFrame = presentedFrame ?? UIScreen.main.bounds
        super.init(nibName: nil, bundle: nil)
        self.childViews.append(subView)
        if let frame = containerFrame {
            self.containerView.frame = frame
        }
        self.addContainerSubview(subView)
        if let viewFrame = presentedFrame {
            self.view.frame = viewFrame
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        // 延迟加载View
        UIView.performWithoutAnimation {
            self.animator.items.initial(nil, presenting: self)
            self.view.addSubview(containerView)
            containerView.setNeedsLayout()
            containerView.layoutIfNeeded() // 提前刷新 用于动画准备
        }
    }
    /// 可用来承载动画的父View
    private func topEnableParentViewController(_ viewController: UIViewController?) -> UIViewController? {
       guard let visible = viewController else { return nil }
       if visible.isBeingDismissed {
           return visible.presentingViewController ?? visible.parent
       } else if visible.isMovingFromParent {
           return visible.parent
       } else {
           return visible
       }
   }
    /// 优先Modal 其次addChildController 最后new Window
    open func show(animated flag: Bool, in controller: UIViewController? = nil, completion: (() -> Void)? = nil) {
        let presnetVC: UIViewController? = controller ?? WQUIHelp.topVisibleViewController()
        if let parentController = topEnableParentViewController(presnetVC) {
            if parentController.presentedViewController != nil {
                 self.shownInParent(parentController, animated: flag, completion: completion)
            } else {
                var fixFlag: Bool = flag
                if #available(iOS 13.0, *) {
                    if parentController.isModalInPresentation { fixFlag = false }
                } else {
                    if parentController.isBeingPresented { fixFlag = false }
                }
                // TODOs:这里不管显示那个控制器 最后都是有当前window的根控制器来控制显示 转场的动画也是根控制器参与动画
                self.presentSelf(in: parentController, animated: fixFlag, completion: completion)
            }
        } else {
           self.shownInWindow(animated: flag, completion: completion)
        }
    }
    /// 被显示
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if self.presentingViewController != nil {
            super.dismiss(animated: flag, completion: completion)
        } else {
            switch showMode {
            case .childController:
                self.hideFromController(animated: flag, completion: completion)
            case .present:
                super.dismiss(animated: flag, completion: completion)
            case .windowRootController:
                self.hideFromWindow(animated: flag, completion: completion)
            case .superChildController:
                self.hideFromParent(animated: flag, completion: completion)
            }
        }
    }
//    #if DEBUG
//    open override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        debugPrint("WQPresentionable:", #function)
//    }
//    open override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        debugPrint("WQPresentionable:", #function)
//    }
//    open override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        debugPrint("WQPresentionable:", #function)
//    }
//    open override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        debugPrint("WQPresentionable:", #function)
//    }
//    #endif
    deinit {
        // 手动置空关联值 防止坏内存引用
        childViews.forEach { $0.presentation = nil }
        self.containerWindow = nil
        debugPrint("\(self):" + #function + "♻️")
    }
    @available(*, unavailable, message: "loading this view from nib not supported" )
    required public init?(coder aDecoder: NSCoder) {
        fatalError("not supported nib")
    }
}
// MARK: - -- UIViewControllerTransitioningDelegate
extension WQTransitionable: UIViewControllerTransitioningDelegate { // 转场管理
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animator
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animator
    }
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard let interactive = self.hidenDriven else { return nil }
            return interactive.isInteractive ? interactive : nil
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard let interactive = self.showDriven else { return nil }
            return interactive.isInteractive ? interactive : nil
    }
}
// MARK: - -- Gesture Handle
extension WQTransitionable {
    @objc
    func handleDismissPanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.hidenDriven?.isInteractive = true
            self.dismiss(animated: true)
        default: break
        }
    }
    @objc
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        debugPrint("======\(#function)")
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
        guard let tapGR = self.tapGesture else { return }
        self.view.removeGestureRecognizer(tapGR)
        self.tapGesture = nil
    }
}
private extension WQTransitionable {
    func configDismissInteractive(for dismissDirection: DrivenDirection?) {
        guard let direction = dismissDirection else {
            self.hidenDriven = nil
            return
        }
        let panGR = UIPanGestureRecognizer()
        if #available(iOS 10.0, *) {
            let driven = WQPropertyDriven(panGR, items: self.animator.items, direction: direction, isShow: false)
            self.hidenDriven = driven
        } else {
            let driven = WQTransitionDriven(gesture: panGR, direction: direction)
            self.hidenDriven = driven
        }
        self.view.addGestureRecognizer(panGR)
        panGR.addTarget(self, action: #selector(handleDismissPanGesture(_:)))
        panGR.delegate = self
    }
}
// MARK: - -- UIGestureRecognizerDelegate
extension WQTransitionable: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tapGR = gestureRecognizer as? UITapGestureRecognizer,
            tapGR === self.tapGesture {
            let location = tapGR.location(in: self.view)
            return !self.containerView.frame.contains(location)
        } else if let interactive = self.hidenDriven {
            return interactive.isEnableDriven(gestureRecognizer)
        }
        return true
    }
}
