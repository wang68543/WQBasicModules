//
//  WQAlertController.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/12.
//

import UIKit
public protocol WQPresentationable: NSObjectProtocol {
    func presentation(_ controller: WQPresentationController, shouldAnimattionSubView from: CGRect, to: CGRect, isShow: Bool) -> CAAnimation
}
open class WQPresentationController: UIViewController {
    public enum TransitionType {
        case none
        case left
        case top
        case right
        case bottom
        case center
    }
    /// 锚点定位动画
    public enum PositionBounceType {
        case bounceCenter // 从0开始从中间弹开
        case bounceVerticalMiddle //横向摊开
        case bounceHorizontalMiddle //纵向摊开
        case bounceVerticalAuto // 基于position 自动计算剩余空间 哪边够显示哪边 默认向右
        case bounceHorizontalAuto // 基于position 默认向下
        case bounceUp //向上弹
        case bounceLeft // 左
        case bounceRight // 右
        case bounceDown // 向下弹
        
    }
    public let containerView: UIView
    
    /// 容器的尺寸
//    public let initialFrame: CGRect
    open var showFrame: CGRect
    open var hideFrame: CGRect
    public let edgeInsets: UIEdgeInsets
    
    /// 当使用构造函数的时候需要初始化尺寸
//    private var isShouldInitialFrames: Bool = false
    private var transitionInitial: TransitionType = .none
    private var transitionShow: TransitionType = .none
    private var transitionDismiss: TransitionType = .none
    
    /// 大背景的颜色
    open var showBackgroundViewColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    open var initialBackgroundViewColor: UIColor = UIColor.clear
    ///动画时长
    public var animateDuration: TimeInterval = 0.25
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
            if isEnableSlideDismiss {
                self.addPanGesture()
            } else {
                self.removePanGesture()
            }
        }
    }
    private var transitionContext: UIViewControllerContextTransitioning?
    
    private let subAnimationKey = "containerViewTransitionKey"
    private let backgroundAnimatioKey = "backgroundTransitionKey"
    private var anmationsCount: Int = 0
    
    private var tapGesture: UITapGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?
    
    /// 默认的尺寸是 按照屏幕大小来显示
    private var viewPresentedFrame: CGRect
    public private(set) var childViews: [UIView] = []
    public init(_ subView: UIView,
                frame show: CGRect,
                dismiss: CGRect,
                initial: CGRect,
                presentedFrame: CGRect = UIScreen.main.bounds,
                contentEdges: UIEdgeInsets = .zero) {
        containerView = UIView()
        showFrame = show
        hideFrame = dismiss
        self.viewPresentedFrame = presentedFrame
        self.edgeInsets = contentEdges
        super.init(nibName: nil, bundle: nil)
        containerView.frame = initial
        self.addContainerSubview(subView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("not supported nib")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containerView)
        
    }
    private func addContainerSubview(_ subView: UIView) {
        containerView.addSubview(subView)
        let metrics = ["top": self.edgeInsets.top,
                     "left": self.edgeInsets.left,
                     "bottom": self.edgeInsets.bottom,
                     "right": self.edgeInsets.right]
        let views = ["subView": subView]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[subView]-right-|", options: .directionMask, metrics: metrics, views: views)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[subView]-bottom-|", options: .directionMask, metrics: metrics, views: views)
        self.containerView.addConstraints(hConstraints)
        self.containerView.addConstraints(vConstraints)
        childViews.append(subView)
    }
    open func show(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let topVC = self.topViewController {
            if topVC.presentedViewController != nil { //已经弹出过控制器
                
            } else {
                self.modalPresentationStyle = .custom
                self.transitioningDelegate = self
                topVC.present(self, animated: flag, completion: completion)
            }
        }
    }
    public var topViewController: UIViewController? {
        var viewController: UIViewController?
        for window in UIApplication.shared.windows.reversed() {
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
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
    }

}

// MARK: - -- Convenience init
public extension WQPresentationController {
    
    /// 根据TransitionType计算尺寸
    ///
    /// - Parameters:
    ///   - size: 中间View的尺寸
    ///   - type: TransitionType
    ///   - presentedFrame: 控制器的frame
    ///   - isInside: 计算的frame是否是在View内 (除了显示的时候在View内部 其余都在外部)
    /// - Returns: 计算好的frame
    private class func frame(_ size: CGSize, type: TransitionType, presentedFrame: CGRect, isInside: Bool = true) -> CGRect {
    
        var origin: CGPoint
        let viewW = presentedFrame.width
        let viewH = presentedFrame.height
        
        switch type {
        case .none:
            origin = .zero
        case .top:
            origin = CGPoint(x: (viewW - size.width) * 0.5, y: isInside ? 0 : -size.height)
        case .left:
            origin = CGPoint(x: isInside ? 0 : -size.width, y: (viewH - size.height) * 0.5)
        case .bottom:
            origin = CGPoint(x: (viewW - size.width) * 0.5, y: isInside ? viewH - size.height : viewH)
        case .right:
            origin = CGPoint(x: isInside ? viewW - size.width : viewW, y: (viewH - size.height) * 0.5)
        case .center:
            origin = CGPoint(x: (viewW - size.width) * 0.5, y: (viewH - size.height) * 0.5)
        }
        return CGRect(origin: origin, size: size)
    }
  
   /// 根据TransitionType计算containerView 三个状态的尺寸
   ///
   /// - Parameters:
   ///   - subView: 显示的View
   ///   - size: contianerView size
   ///   - initial: 初始的方位
   ///   - show: 显示的w方位
   ///   - dismiss: 消失的方位
   ///   - presentedFrame: 控制器的尺寸
   public convenience init(transitionType subView: UIView, size: CGSize, initial: TransitionType, show: TransitionType, dismiss: TransitionType, presentedFrame: CGRect = UIScreen.main.bounds) {
        let initialFrame: CGRect = WQPresentationController.frame(size, type: initial, presentedFrame: presentedFrame, isInside: false)
        let showFrame: CGRect = WQPresentationController.frame(size, type: show, presentedFrame: presentedFrame, isInside: false)
        let dismissFrame: CGRect = WQPresentationController.frame(size, type: dismiss, presentedFrame: presentedFrame, isInside: false)
    
        self.init(subView, frame: showFrame, dismiss: dismissFrame, initial: initialFrame, presentedFrame: presentedFrame, contentEdges: .zero)
        transitionInitial = initial
        transitionShow = show
        transitionDismiss = dismiss
    }
    /// 从哪里显示出来的就从哪里消失
    ///
    /// - Parameters:
    ///   - initial: 初始方位
    ///   - show: 显示的方位
    public convenience init(transitionReverse subView: UIView, size: CGSize, initial: TransitionType, show: TransitionType) {
        self.init(transitionType: subView, size: size, initial: initial, show: show, dismiss: initial)
    }
    
    /// 根据position和size来显示View
    ///
    /// - Parameters:
    ///   - subView: 显示的View
    ///   - point: contianerView的position(计算的时候回包含anchorPoint)
    ///   - size: contianerView的size
    ///   - bounceType: contianerView展开类型
    ///   - presentedFrame: 控制器的尺寸
    public convenience init(position subView: UIView, to point: CGPoint, size: CGSize, bounceType: PositionBounceType = .bounceHorizontalMiddle, presentedFrame: CGRect = UIScreen.main.bounds) {
        let anchorPoint = subView.layer.anchorPoint
        let positionPt = CGPoint(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height)
        let showFrame = CGRect(origin: positionPt, size: size)
        var initialFrame: CGRect
        switch bounceType {
        case .bounceVerticalAuto:
            if size.width + positionPt.x > presentedFrame.width { //向左
                initialFrame = CGRect(x: point.x + anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height, width: 0, height: size.height)
            } else {
                initialFrame = CGRect(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height, width: 0, height: size.height)
            }
        case .bounceHorizontalAuto:
            if size.height + positionPt.y > presentedFrame.height {
                initialFrame = CGRect(x: point.x - anchorPoint.x * size.width, y: point.y + anchorPoint.y * size.height, width: size.width, height: 0)
            } else {
                initialFrame = CGRect(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height, width: size.width, height: 0)
            }
        case .bounceCenter:
            initialFrame = CGRect(origin: positionPt, size: .zero)
        case .bounceHorizontalMiddle:
            initialFrame = CGRect(x: point.x - anchorPoint.x * size.width, y: point.y, width: size.width, height: 0)
        case .bounceVerticalMiddle:
            initialFrame = CGRect(x: point.x, y: point.y - anchorPoint.y * size.height, width: 0, height: size.height)
        case .bounceUp:
            initialFrame = CGRect(x: point.x - anchorPoint.x * size.width, y: point.y + anchorPoint.y * size.height, width: size.width, height: 0)
        case .bounceDown:
            initialFrame = CGRect(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height, width: size.width, height: 0)
        case .bounceLeft:
            initialFrame = CGRect(x: point.x + anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height, width: 0, height: size.height)
        case .bounceRight:
            initialFrame = CGRect(x: point.x - anchorPoint.x * size.width, y: point.y - anchorPoint.y * size.height, width: 0, height: size.height)
            
        }
        self.init(subView, frame: showFrame, dismiss: initialFrame, initial: initialFrame, presentedFrame: presentedFrame)
    }
    //
    public convenience init(anchor subView: UIView, anchorView: UIView, size: CGSize, bounceType: PositionBounceType = .bounceHorizontalMiddle) {
        guard !UIApplication.shared.windows.isEmpty else {
            fatalError("必须有窗口才行")
        }
        var window: UIWindow
        if let keyWindow = UIApplication.shared.keyWindow {
            window = keyWindow
        } else {
            var winView: UIWindow?
            for window in UIApplication.shared.windows.reversed() {
                if window.windowLevel < UIWindow.Level.alert {
                    winView = window
                    break
                }
            }
            if winView == nil {
                window = UIApplication.shared.windows.last!
            } else {
                window = winView!
            }
        }
        let presentionFrame = window.frame
        let rect = anchorView.convert(anchorView.frame, to: window)
        var postion: CGPoint
        switch bounceType {
        case .bounceHorizontalMiddle, .bounceVerticalMiddle, .bounceCenter:
            postion = CGPoint(x: rect.midX, y: rect.midY)
        case .bounceVerticalAuto:
            if rect.maxX + size.width > presentionFrame.width {
                postion = CGPoint(x: rect.minX, y: rect.midY)
            } else {
                postion = CGPoint(x: rect.maxX, y: rect.midY)
            }
        case .bounceHorizontalAuto:
            if rect.maxY + size.height > presentionFrame.height {
                postion = CGPoint(x: rect.midX, y: rect.midY)
            } else {
                postion = CGPoint(x: rect.maxX, y: rect.midY)
            }
        case .bounceUp:
            postion = CGPoint(x: rect.midX, y: rect.minY)
        case .bounceDown:
            postion = CGPoint(x: rect.midX, y: rect.maxY)
        case .bounceLeft:
            postion = CGPoint(x: rect.minX, y: rect.midY)
        case .bounceRight:
            postion = CGPoint(x: rect.maxX, y: rect.midY)
        }
        self.init(position: subView, to: postion, size: size, bounceType: bounceType, presentedFrame: presentionFrame)
    }
}
// MARK: - -- Animations
public extension WQPresentationController {
    func subViewAnimate(_ from: CGRect, to: CGRect, isShow: Bool = true) -> CAAnimation {
        let keyPath = "frame"
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = self.animateDuration
        return animation
    }
    func backgroundAnimate(_ from: UIColor, to: UIColor) -> CAAnimation {
        let keyPath = "backgroundColor"
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = self.animateDuration
        return animation
    }
}

// MARK: - -- Gesture Handle
extension WQPresentationController {
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer)  {
        
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer)  {
        
    }
    
    func addTapGesture() {
        self.removeTapGesture()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGR.delegate = self
        self.view.addGestureRecognizer(tapGR)
        self.tapGesture = tapGR
    }
    func addPanGesture() {
        self.removePanGesture()
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGR)
        self.panGesture = panGR
    }
    
    func removeTapGesture()  {
        guard let tapGR = self.tapGesture else {
            return
        }
        self.view.removeGestureRecognizer(tapGR)
    }
    func removePanGesture() {
        guard let panGR = self.panGesture else {
            return
        }
        self.view.removeGestureRecognizer(panGR)
    }
}

// MARK: - -- UIViewControllerAnimatedTransitioning
extension WQPresentationController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animateDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
//        let vcInitialFrame = transitionContext.initialFrame(for: fromVC)
        let vcFinalFrame = transitionContext.finalFrame(for: toVC)
        let toVCView = transitionContext.view(forKey: .to)
//        let fromVCView = transitionContext.view(forKey: .from)
        let isPresented = toVC.presentingViewController === fromVC
        self.transitionContext = transitionContext
        let transitionView = transitionContext.containerView
      
        var subAnimate: CAAnimation
        var backgroundAnimation: CAAnimation
        if isPresented {//初始化
            if let toView = toVCView {
                toView.frame = vcFinalFrame
                transitionView.addSubview(toView)
            }
            subAnimate =  self.subViewAnimate(self.containerView.frame, to: showFrame)
            backgroundAnimation = self.backgroundAnimate(initialBackgroundViewColor, to: showBackgroundViewColor)
        } else {
            subAnimate =  self.subViewAnimate(showFrame, to: hideFrame)
            backgroundAnimation = self.backgroundAnimate(showBackgroundViewColor, to: initialBackgroundViewColor)
        }
        anmationsCount = 2
        subAnimate.delegate = self
        self.containerView.layer.add(subAnimate, forKey: subAnimationKey)
        backgroundAnimation.delegate = self
        toVCView?.layer.add(backgroundAnimation, forKey: backgroundAnimatioKey)
    }
    
}

// MARK: - -- CAAnimation Delegate
extension WQPresentationController: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        anmationsCount -= 1
        guard let context = self.transitionContext,
          anmationsCount <= 0 else {
            return
        }
        context.completeTransition(!context.transitionWasCancelled)
        self.transitionContext = nil
    }
}

// MARK: - -- UIGestureRecognizerDelegate
extension WQPresentationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let tapGR = gestureRecognizer as? UITapGestureRecognizer{
            let location = tapGR.location(in: self.view)
            if self.containerView.frame.contains(location) {
                return false
            }
        }
        return true
    }
}

// MARK: - -- UIViewControllerTransitioningDelegate
extension WQPresentationController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}

// MARK: - -- Default WQPresentationable impelement
private extension WQPresentationable {
    func presentation(_ controller: WQPresentationController, shouldAnimattionSubView from: CGRect, to: CGRect, isShow: Bool) -> CAAnimation {
        return controller.subViewAnimate(from, to: to, isShow: isShow)
    }
}
