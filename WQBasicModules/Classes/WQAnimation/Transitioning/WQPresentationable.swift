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
}

public let WQContainerWindowLevel: UIWindow.Level = .alert - 4.0

open class WQPresentationable: UIViewController {
    public let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    public let animator: WQTransitioningAnimator
    // 显示的时候的交互动画 暂时只支持present动画
    public var showInteractive: WQDrivenTransition?
    /// 滑动交互消失的方向
    public var interactionDissmissDirection: WQDrivenTransition.Direction? {
        didSet {
            if let direction = interactionDissmissDirection {
                let panGR = UIPanGestureRecognizer()
                let driven = WQDrivenTransition(gesture: panGR, direction: direction)
                self.view.addGestureRecognizer(panGR)
                panGR.addTarget(self, action: #selector(handleDismissPanGesture(_:)))
                panGR.delegate = self
                self.hideInteracitve = driven
            } else {
                self.hideInteracitve = nil
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
    /// 容器的尺寸
    public private(set) var hideInteracitve: WQDrivenTransition?
    ///containerView上的子View 用于转场动画切换
    public private(set) var childViews: [UIView] = []
    /// 是否是Modal出来的
    public internal(set) var shownMode: WQShownMode = .present
    /// 主要用于搜索containerView上当前正在显示的View包含的输入框
    private var contentViewInputs: [UITextInput] = []
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
            //TODO:这里不管显示那个控制器 最后都是有当前window的根控制器来控制显示 转场的动画也是根控制器参与动画
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
        //保证使用全屏的View
    if let navgationController = controller.navigationController {
        topVC = navgationController
    } else if let tabBarController = controller.tabBarController { //如果是他tabBar的话 会自动重新布局
        topVC = tabBarController
    } else {
        topVC = controller
    }
    shouldUsingPresentionAnimatedController = controller
    if topVC === controller {
        //底下的view不能做动画了
    }
    //动画的时候用可见的ViewController 尽量确保当前View 与Visable的View在同一个坐标系下 然后动画的时候用当前的控制器动画
        topVC.addChild(self)
        topVC.view.addSubview(self.view)
        if flag {
            self.animator.animated(presented: controller, presenting: self, isShow: true) { [weak self] _ in
                guard let weakSelf = self else {
                    completion?()
                    return
                }
                weakSelf.didMove(toParent: topVC)
                completion?()
            }
        } else {
            self.animator.items.config(controller, presenting: self, isShow: true)
            self.didMove(toParent: topVC)
            completion?()
        }
        interactionDissmissDirection = nil
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
            self.animator.animated(presented: self.shouldUsingPresentionAnimatedController,
                                   presenting: self,
                                   isShow: false) { _ in
                animateFinshed()
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
// MARK: - -- Help
private extension WQPresentationable {
    private func addContainerSubview(_ subView: UIView) {
        subView.presentation = self
        containerView.addSubview(subView)
        addConstraints(for: subView)
    }
    private func addConstraints(for subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: containerView.topAnchor),
            subView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            subView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)])
    }
}
// MARK: - -- Gesture Handle
extension WQPresentationable {
    @objc
    func handleDismissPanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.hideInteracitve?.isInteracting = true
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

// MARK: - keyboard
public extension WQPresentationable {
     private func searchTextInputs(_ inView: UIView) -> [UITextInput] {
        var inputViews: [UITextInput] = []
        if let textInput = inView as? UITextInput {
            inputViews.append(textInput)
        } else {
            if !inView.subviews.isEmpty {
                inView.subviews.forEach { view in
                    inputViews.append(contentsOf: self.searchTextInputs(view))
                }
            }
        }
        return inputViews
    }
    func addKeyboardObserver() {
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self,
                                  selector: #selector(keyboardWillChangeFrame(_:)),
                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                  object: nil)
        defaultCenter.addObserver(self,
                                  selector: #selector(keyboardDidChangeFrame(_:)),
                                  name: UIResponder.keyboardDidChangeFrameNotification,
                                  object: nil)
    }
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil) 
    }
    @objc
    func keyboardWillChangeFrame(_ note: Notification) {
       keyboardChangeAnimation(note: note)
    }
    @objc
    func keyboardDidChangeFrame(_ note: Notification) {
        keyboardChangeAnimation(note: note)
    }
    private func keyboardChangeAnimation(note: Notification) {
        if contentViewInputs.isEmpty {
            contentViewInputs = self.searchTextInputs(self.containerView)
        }
        guard let textInput = contentViewInputs.first(where: { textInput -> Bool in
            if let inputView = textInput as? UIResponder {
                return inputView.isFirstResponder
            }
            return false
        }),
            let inputView = textInput as? UIView,
            let inputSuperView = inputView.superview else {
                return
        }
        guard let keyboardF = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ,
            let options = note.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationOptions,
            let keyWindow = UIApplication.shared.keyWindow else {
                return
        }
        let contentF = inputSuperView.convert(inputView.frame, to: keyWindow)
        let intersectFrame = contentF.intersection(keyboardF)
        let position = self.containerView.layer.position
        let targetPosition = CGPoint(x: position.x, y: position.y - intersectFrame.height - 10) 
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.containerView.layer.position = targetPosition
        })
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
        } else if let interactive = self.hideInteracitve {
            return interactive.isEnableDriven(gestureRecognizer)
        }
        return true
    }
}
// MARK: - -- UIViewControllerTransitioningDelegate
extension WQPresentationable: UIViewControllerTransitioningDelegate {
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
        guard let interactive = self.hideInteracitve else {
            return nil
        }
        return interactive.isInteracting ? interactive : nil
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
        guard let interactive = self.showInteractive else {
            return nil
        }
        return interactive.isInteracting ? interactive : nil
    }
}
