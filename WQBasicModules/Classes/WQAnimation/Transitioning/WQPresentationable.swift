//
//  WQAlertController.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/12.
//
import UIKit

/// 专职于显示Alert的Window
class WQPresentationWindow: UIWindow { }

public let WQContainerWindowLevel: UIWindow.Level = .alert - 4.0
/// 解决 iOS10之前以及非Modal形式的动画无法手势驱动问题
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
    
    /// 容器View 所有的View都需要成为当前View的子View
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
                self.keyboardManager = WQKeyboardManager(self.containerView) 
            } else {
                self.keyboardManager = nil
            }
        }
    }
    /// 是否是Modal出来的
    public internal(set) var shownMode: WQShownMode = .present 
    ///containerView上的子View 用于转场动画切换
    public internal(set) var childViews: [UIView] = []
    /// 主要用于搜索containerView上当前正在显示的View包含的输入框
    internal var contentViewInputs: [TextFieldView] = []
    internal var tapGesture: UITapGestureRecognizer?
    
    /// shownInWindow的时候 记录的属性 用于消失之后恢复
    internal weak var previousKeyWindow: UIWindow?
    //用于容纳当前控制器的window窗口
    internal var containerWindow: WQPresentationWindow?
    
    /// 非present的时候 用于动画管理器里面的转场动画
    internal weak var shouldUsingPresentionAnimatedController: UIViewController?
    
    /// 是否要对presentedVC 进行生命周期(调用viewWillApperace...)
    public var shouldViewWillApperance: Bool = false
    
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
//         containerView.layoutIfNeeded()
    }
    /// 刷新子子控件的布局
    private func layoutContainerSubViews() {
        if #available(iOS 9.0, *) {
            self.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
        }
        containerView.setNeedsUpdateConstraints()
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
    }
    /// 优先Modal 其次addChildController 最后new Window
    open func show(animated flag: Bool, in controller: UIViewController? = nil, completion: (() -> Void)? = nil) {
        let presnetVC: UIViewController? = controller ?? WQUIHelp.topVisibleViewController()
        self.layoutContainerSubViews()
        if presnetVC?.presentingViewController != nil {
            self.shownInParent(presnetVC!, animated: flag, completion: completion)
        } else if let topVC = presnetVC {
            //TODOs:这里不管显示那个控制器 最后都是有当前window的根控制器来控制显示 转场的动画也是根控制器参与动画
            self.presentSelf(in: topVC, animated: flag, completion: completion)
        } else {
            self.shownInWindow(animated: flag, completion: completion)
        }
    }
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        switch shownMode {
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
   
    deinit {
        //手动置空关联值 防止坏内存引用
        childViews.forEach { $0.presentation = nil }
        self.containerWindow = nil
        debugPrint("弹出框控制器销毁了")
    }
    @available(*, unavailable, message: "loading this view from nib not supported" )
    required public init?(coder aDecoder: NSCoder) {
        fatalError("not supported nib")
    }
}
// MARK: - -- UIViewControllerTransitioningDelegate
extension WQPresentationable: UIViewControllerTransitioningDelegate { // 转场管理
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard let interactive = self.hidenDriven else { return nil }
            return interactive.isInteractive ? interactive : nil
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard let interactive = self.showInteractive else { return nil }
            return interactive.isInteractive ? interactive : nil
    }
}

// MARK: - -- UIViewControllerAnimatedTransitioning
extension WQPresentationable: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animator.duration
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        let vcFinalFrame = transitionContext.finalFrame(for: toVC)
        let isPresented = toVC.presentingViewController === fromVC
        let toVCView = transitionContext.view(forKey: .to)
        let transitionView = transitionContext.containerView
        if let toView = toVCView {
            toView.frame = vcFinalFrame
            transitionView.addSubview(toView)
        }
        let animateCompletion: WQAnimateCompletion = { flag -> Void in
            let success = !transitionContext.transitionWasCancelled
            if (isPresented && !success) || (!isPresented && success) {
                toVCView?.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
        if isPresented {
            self.animator.animated(presented: fromVC, presenting: toVC, isShow: true, completion: animateCompletion)
        } else {
            self.animator.animated(presented: toVC, presenting: fromVC, isShow: false, completion: animateCompletion)
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
        default: break
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
        guard let tapGR = self.tapGesture else { return }
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
            return !self.containerView.frame.contains(location)
        } else if let interactive = self.hidenDriven {
            return interactive.isEnableDriven(gestureRecognizer)
        }
        return true
    }
}
