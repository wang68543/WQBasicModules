//
//  WQAlertController.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/12.
//
import UIKit

open class WQPresentationable: UIViewController {
    public let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    public let animator: WQTransitioningAnimator
    /// 容器的尺寸
    public private(set) var hideInteracitve: WQDrivenTransition?
    public var showInteractive: WQDrivenTransition?
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
    open var isEnableKeyboardObserver: Bool = false {
        didSet {
            if isEnableKeyboardObserver {
                self.addKeyboardObserver()
            } else {
                self.removeKeyboardObserver()
            }
        }
    }
    private var tapGesture: UITapGestureRecognizer?
    public private(set) var childViews: [UIView] = []
    /// 是否是Modal出来的
    private var isModal: Bool = true
    private var contentViewInputs: [UITextInput] = []
    
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
        let presnetVC: UIViewController? = controller ?? self.topViewController
        if let topVC = presnetVC {
            if topVC.presentedViewController != nil { //已经弹出过控制器
                self.showInParent(topVC, flag: flag, completion: completion)
            } else {
                topVC.modalPresentationStyle = .custom
                topVC.transitioningDelegate = self
                self.modalPresentationStyle = .custom
                self.transitioningDelegate = self
                topVC.present(self, animated: flag, completion: completion)
            }
        } else {
            debugPrint("没有依赖控制器")
        }
    }
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if !isModal {
            hideFromParent(animated: flag, completion: completion)
        } else {
           super.dismiss(animated: flag, completion: completion)
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
        childViews.forEach { $0.wm.setPresenter(nil) }
        debugPrint("控制器销毁了")
    }
    @available(*, unavailable, message: "loading this view from nib not supported" )
    required public init?(coder aDecoder: NSCoder) {
        fatalError("not supported nib")
    }
}
// MARK: - -- Help
private extension WQPresentationable {
    private func addContainerSubview(_ subView: UIView) {
        subView.wm.setPresenter(self)
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
    private func showInParent(_ controller: UIViewController, flag: Bool, completion: (() -> Void)?) {
        var showInVC: UIViewController = controller
        if let tabBarVC = showInVC.tabBarController {
            showInVC = tabBarVC
        } else if let navVC = showInVC.navigationController {
            showInVC = navVC
        }
        showInVC.addChild(self)
        showInVC.view.addSubview(self.view)
        if flag {
            self.animator.animated(presented: showInVC, presenting: self, isShow: true) { [weak self] _ in
                guard let weakSelf = self else {
                    completion?()
                    return
                }
                weakSelf.didMove(toParent: showInVC)
                completion?()
            }
        } else {
            self.animator.items.config(showInVC, presenting: self, isShow: true)
            self.didMove(toParent: showInVC)
            completion?()
        }
        isModal = false
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
            self.animator.items.config(self.parent, presenting: self, isShow: false)
            animateFinshed()
        } else {
            self.animator.animated(presented: self.parent, presenting: self, isShow: false) { _ in
                animateFinshed()
            }
        }
    }
    
    private var topViewController: UIViewController? {
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
    
    private func findTopViewController(in viewController: UIViewController) -> UIViewController? {
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
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.containerView.layer.position = CGPoint(x: position.x, y: position.y - intersectFrame.height - 10)
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
