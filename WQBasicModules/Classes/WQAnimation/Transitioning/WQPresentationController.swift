//
//  WQAlertController.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/12.
//
// swiftlint:disable line_length
import UIKit
public final class WQModules<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}
public protocol WQModulesCompatible {
    associatedtype WQModulesType
    // swiftlint:disable identifier_name
    var wm: WQModulesType { get }
}
public extension WQModulesCompatible {
    // swiftlint:disable identifier_name
    var wm: WQModules<Self> {
        return WQModules(self)
    }
}
extension UIView: WQModulesCompatible { }

private var presenterKey: Void?

extension WQModules where Base: UIView {
   public var presenter: UIViewController? {
        return objc_getAssociatedObject(self.base, &presenterKey) as? UIViewController
    }
    
    fileprivate func setPresenter(_ viewController: UIViewController? ) {
        objc_setAssociatedObject(self.base, &presenterKey, viewController, .OBJC_ASSOCIATION_ASSIGN)
    }
    /// 需要提前配置一些动画参数
    func preperAnimator(from: WQPresentionStyle.Position,
                        show: WQPresentionStyle.Position,
                        hide: WQPresentionStyle.Position) -> WQTransitioningAnimator {
        let presention = WQPresentationController(transitionType: self.base, size: self.base.frame.size, initial: from, show: show, dismiss: hide)
        self.setPresenter(presention)
        return presention.transitioningAnimator
    }
    /// 动画参数配置完成之后展示
    func present(in viewController: UIViewController?, completion: (() -> Void)? = nil) {
        if let presention = self.presenter as? WQPresentationController {
            presention.show(animated: true, in: viewController, completion: completion)
        }
    }
    /// 采用默认的动画风格展示
    public func show(from: WQPresentionStyle.Position,
                     show: WQPresentionStyle.Position,
                     hide: WQPresentionStyle.Position,
                     inController: UIViewController? = nil) {
        _ = self.preperAnimator(from: from, show: show, hide: hide)
        self.present(in: inController)
    }
    public func show(reverse from: WQPresentionStyle.Position,
                     to: WQPresentionStyle.Position,
                     inController: UIViewController? = nil) {
        self.show(from: from, show: to, hide: from, inController: inController)
    }
    public func dismiss(_ animated: Bool, completion: (() -> Void)? = nil) {
        self.presenter?.dismiss(animated: true, completion: completion)
    }
}

open class WQPresentationController: UIViewController {
 
    public let containerView: UIView

    public let transitioningAnimator: WQTransitioningAnimator
    /// 容器的尺寸
    public private(set) var drivenInteracitve: WQPercentDrivenInteractive?
    public var interactionDissmissDirection: WQPercentDrivenInteractive.Direction = .none {
        didSet {
            guard let ineractive = self.drivenInteracitve else {
                return
            }
            ineractive.direction = interactionDissmissDirection
        }
    }
    /// 大背景的颜色
    open var showBackgroundViewColor: UIColor {
        didSet {
            self.transitioningAnimator.showBackgroundViewColor = showBackgroundViewColor
        }
    }
    open var initialBackgroundViewColor: UIColor {
        didSet {
            self.transitioningAnimator.initialBackgroundViewColor = initialBackgroundViewColor
        }
    }
    ///动画时长
    public var animateDuration: TimeInterval {
        didSet {
            self.transitioningAnimator.duration = animateDuration
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
    /// 是否支持滑动消失
    open var isEnableSlideDismiss: Bool = false {
        didSet {
            guard self.isModal else {
                self.drivenInteracitve = nil
                return
            }
            if isEnableSlideDismiss {
                self.drivenInteracitve = WQPercentDrivenInteractive(interactionDissmissDirection, size: self.transitioningAnimator.showFrame.size, gestureView: self.view)
                self.drivenInteracitve?.starShowConfig = { [weak self] type in
                    switch type {
                    case .dismiss:
                        self?.dismiss(animated: true)
                    default:
                        break
                    }
                }
                self.drivenInteracitve?.panGesture.delegate = self
            } else {
                self.drivenInteracitve = nil
            }
        }
    }
    private var tapGesture: UITapGestureRecognizer?
    
    /// 默认的尺寸是 按照屏幕大小来显示
    private var viewPresentedFrame: CGRect
    public private(set) var childViews: [UIView] = []
    /// 是否是Modal出来的
    private var isModal: Bool = true
    
    public init(_ subView: UIView,
                frame show: CGRect,
                dismiss: CGRect,
                initial: CGRect,
                presentedFrame: CGRect = UIScreen.main.bounds) {
        containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        let animator = WQTransitioningAnimator(containerView, show: show, hide: dismiss)
        transitioningAnimator = animator
        initialBackgroundViewColor = animator.initialBackgroundViewColor
        showBackgroundViewColor = animator.showBackgroundViewColor
        animateDuration = animator.duration
        self.viewPresentedFrame = presentedFrame
        super.init(nibName: nil, bundle: nil)
       self.defaultInitial(subView, initalFrame: initial)
    }
    private func defaultInitial(_ subView: UIView, initalFrame: CGRect) {
        containerView.frame = initalFrame
        self.childViews.append(subView)
        self.addContainerSubview(subView)
    }
   
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("not supported nib")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
      
    }
    private func addContainerSubview(_ subView: UIView) {
        subView.wm.setPresenter(self)
        self.view.addSubview(containerView)
        containerView.addSubview(subView)
        addConstraints(for: subView)
        containerView.setNeedsDisplay()
        containerView.layoutIfNeeded()
    }
    private func addConstraints(for subView: UIView) {
//        subView.frame = containerView.frame
        subView.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: subView, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1.0, constant: 0)
        let right = NSLayoutConstraint(item: subView, attribute: .right, relatedBy: .equal, toItem: containerView, attribute: .right, multiplier: 1.0, constant: 0)
        let top = NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0)
        containerView.addConstraints([left, right, bottom, top])
    }
    open func show(animated flag: Bool, in controller: UIViewController? = nil, completion: (() -> Void)? = nil) {
        let presnetVC: UIViewController? = controller ?? self.topViewController
        if let topVC = presnetVC {
            if topVC.presentedViewController != nil { //已经弹出过控制器
                var showInVC: UIViewController = topVC
                if let tabBarVC = topVC.tabBarController {
                    showInVC = tabBarVC
                } else if let navVC = topVC.navigationController {
                     showInVC = navVC
                }
                
               showInVC.addChild(self)
               showInVC.view.addSubview(self.view)
                self.didMove(toParent: showInVC)
                self.transitioningAnimator
                    .defaultAnimated(self.view,
                                     animatedView: self.containerView,
                                     isShow: true,
                                     completion: { flag in
                                     completion?()
                    }) 
                isModal = false
                isEnableSlideDismiss = false
            } else {
                topVC.modalPresentationStyle = .custom
                topVC.transitioningDelegate = self
                self.modalPresentationStyle = .custom
                self.transitioningDelegate = self
                topVC.present(self, animated: flag, completion: completion)
                if !flag {
                    self.view.backgroundColor = self.transitioningAnimator.showBackgroundViewColor
                    self.containerView.frame = self.transitioningAnimator.showFrame
                }
            }
        }
    }

    public var topViewController: UIViewController? {
        var viewController: UIViewController?
        let windows = UIApplication.shared.windows.reversed()
        for window in  windows {
            let windowCls = type(of: window).description()
            if windowCls == "UIRemoteKeyboardWindow" || windowCls == "UITextEffectsWindow" {
                continue
            }
            if let rootVC = window.rootViewController,
                let topVC = self.findTopViewController(in: rootVC) {
                viewController = topVC
                break
            }
        }
        return viewController
    }
    
    public func findTopViewController(in viewController: UIViewController) -> UIViewController? {
        if let tabBarController = viewController as? UITabBarController {
            if let selectedController = tabBarController.selectedViewController {
                return self.findTopViewController(in: selectedController)
            } else {
                return tabBarController
            }
        } else if let navgationController = viewController as? UINavigationController {
            if let navTopController = navgationController.topViewController {
                return self.findTopViewController(in: navTopController)
            } else {
                return navgationController
            }
        } else {
            return viewController
        }
    }
    private func hideFromParent(animated flag: Bool, completion: (() -> Void)? ) {
        if !flag {
            completion?()
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        } else {
            self.transitioningAnimator
                .defaultAnimated(self.view,
                                 animatedView: self.containerView,
                                 isShow: false,
                                 completion: { [weak self] flag in
                                    if let weakSelf = self {
                                        completion?()
                                        weakSelf.willMove(toParent: nil)
                                        weakSelf.view.removeFromSuperview()
                                        weakSelf.removeFromParent()
                                    }
                })
        }
    }
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if !isModal {
            hideFromParent(animated: flag, completion: completion)
        } else {
           super.dismiss(animated: flag, completion: completion)
        }
    }
    deinit {
        debugPrint("控制器销毁了")
    }
}

// MARK: - -- Convenience init
public extension WQPresentationController {
    /// 根据TransitionType计算containerView 三个状态的尺寸
    ///
    /// - Parameters:
    ///   - subView: 显示的View
    ///   - size: contianerView size
    ///   - initial: 初始的方位
    ///   - show: 显示的w方位
    ///   - dismiss: 消失的方位
    ///   - presentedFrame: 控制器的尺寸
    convenience
    init(transitionType subView: UIView,
         size: CGSize,
         initial: WQPresentionStyle.Position,
         show: WQPresentionStyle.Position,
         dismiss: WQPresentionStyle.Position,
         presentedFrame: CGRect = UIScreen.main.bounds) {
        let initialFrame = initial.frame(size, presentedFrame: presentedFrame, isInside: false)
        let showFrame = show.frame(size, presentedFrame: presentedFrame, isInside: true)
        let dismissFrame = dismiss.frame(size, presentedFrame: presentedFrame, isInside: false)
        self.init(subView, frame: showFrame, dismiss: dismissFrame, initial: initialFrame, presentedFrame: presentedFrame)
        /// 这里只是配置默认的消失交互方向 但是不开启 需要手动开启
        interactionDissmissDirection = dismiss.mapInteractionDirection()
    }
    
    /// 根据position和size来显示View
    ///
    /// - Parameters:
    ///   - subView: 显示的View
    ///   - point: contianerView的position(计算的时候回包含anchorPoint)
    ///   - size: contianerView的size
    ///   - bounceType: contianerView展开类型
    ///   - presentedFrame: 控制器的尺寸
    convenience
    init(position subView: UIView,
         to point: CGPoint,
         size: CGSize,
         bounceType: WQPresentionStyle.Bounce = .horizontalMiddle,
         presentedFrame: CGRect = UIScreen.main.bounds) {
        let anchorPoint = subView.layer.anchorPoint
        let positionPt = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height)
        let showFrame = CGRect(origin: positionPt, size: size)
        let initialFrame: CGRect = bounceType.estimateInitialFrame(point, anchorPoint: anchorPoint, size: size, presentedFrame: presentedFrame)
        self.init(subView, frame: showFrame, dismiss: initialFrame, initial: initialFrame, presentedFrame: presentedFrame)
    }
    
    convenience
    init(position subView: UIView,
         show: WQPresentionStyle.Position,
         size: CGSize,
         bounceType: WQPresentionStyle.Bounce = .horizontalMiddle,
         presentedFrame: CGRect = UIScreen.main.bounds) {
        let anchorPoint = subView.layer.anchorPoint
        let showFrame = show.frame(size, presentedFrame: presentedFrame, isInside: true)
        let point = CGPoint(x: showFrame.minX + showFrame.width * anchorPoint.x, y: showFrame.minY + showFrame.height * anchorPoint.y)
        let initialFrame: CGRect = bounceType.estimateInitialFrame(point, anchorPoint: anchorPoint, size: size, presentedFrame: presentedFrame)
        self.init(subView, frame: showFrame, dismiss: initialFrame, initial: initialFrame, presentedFrame: presentedFrame)
    }
    /// 从哪里显示出来的就从哪里消失
    ///
    /// - Parameters:
    ///   - initial: 初始方位
    ///   - show: 显示的方位
    convenience
    init(transitionReverse subView: UIView,
         size: CGSize,
         initial: WQPresentionStyle.Position,
         show: WQPresentionStyle.Position) {
        self.init(transitionType: subView, size: size, initial: initial, show: show, dismiss: initial)
    }
    //
   convenience
    init(anchor subView: UIView,
         anchorView: UIView,
         size: CGSize,
         bounceType: WQPresentionStyle.Bounce = .horizontalMiddle) {
        guard !UIApplication.shared.windows.isEmpty else {
            fatalError("必须有窗口才行")
        }
        var window: UIWindow
        if let keyWindow = UIApplication.shared.keyWindow {
            window = keyWindow
        } else {
            if let win = UIApplication.shared.windows.reversed().first(where: ({ $0.windowLevel < UIWindow.Level.alert })) {
                window = win
            } else {
                window = UIApplication.shared.windows.last!
            }
        }
        let presentionFrame = window.frame
        let rect = anchorView.convert(anchorView.frame, to: window)
        let position = bounceType.postion(rect, size: size, presentedFrame: presentionFrame)
        self.init(position: subView, to: position, size: size, bounceType: bounceType, presentedFrame: presentionFrame)
    }
    
}

// MARK: - -- Gesture Handle
extension WQPresentationController {
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
    }
}

// MARK: - keyboard
public extension WQPresentationController {
     func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil) 
    }
    @objc
    func keyboardWillChangeFrame(_ note: Notification) {
        
    }
    @objc
    func keyboardDidChangeFrame(_ note: Notification) {
        
    }
}
// MARK: - -- UIGestureRecognizerDelegate
extension WQPresentationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tapGR = gestureRecognizer as? UITapGestureRecognizer,
            tapGR === self.tapGesture {
            let location = tapGR.location(in: self.view)
            if self.containerView.frame.contains(location) {
                return false
            }
        } else if let interactive = self.drivenInteracitve {
            return interactive.shouldBeginInteractive(gestureRecognizer)
        }
        return true
    }
}

// MARK: - -- UIViewControllerTransitioningDelegate
extension WQPresentationController: UIViewControllerTransitioningDelegate {
   public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transitioningAnimator
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transitioningAnimator
    }
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interactive = self.drivenInteracitve else {
            return nil
        }
        return interactive.isInteracting ? interactive : nil
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}