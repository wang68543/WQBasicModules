//
//  WQAlertController.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/12.
//

import UIKit
public enum WQTransitionEdge {
    case none
    case left
    case top
    case right
    case bottom
    case middle  
}
open class WQPresentationController: UIViewController {
    public let containerView: UIView
    
    /// 容器的尺寸
    public let initialFrame: CGRect
    open var showFrame: CGRect
    open var hideFrame: CGRect
    open var edgeInsets: UIEdgeInsets = .zero
    
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
    
    public init(_ subView: UIView, frame initial: CGRect, show: CGRect, dismiss: CGRect) {
        containerView = UIView()
        initialFrame = initial
        showFrame = show
        hideFrame = dismiss
        super.init(nibName: nil, bundle: nil)
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
    }
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        
    }
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
    }

}
// MARK: - animations
extension WQPresentationController {
    func subViewAnimate(_ from: CGRect, to: CGRect) -> CAAnimation {
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

// MARK: - gesture handle
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
    func removePanGesture()  {
        guard let panGR = self.panGesture else {
            return
        }
        self.view.removeGestureRecognizer(panGR)
    }
}
extension WQPresentationController : UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animateDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        let vcInitialFrame = transitionContext.initialFrame(for: fromVC)
        let vcFinalFrame = transitionContext.finalFrame(for: toVC)
        let toVCView = transitionContext.view(forKey: .to)
        let fromVCView = transitionContext.view(forKey: .from)
        let isPresented = toVC.presentingViewController === fromVC
        self.transitionContext = transitionContext
        let transitionView = transitionContext.containerView
      
        var subAnimate: CAAnimation
        var backgroundAnimation: CAAnimation
        if isPresented {//初始化
            if let toView = toVCView {
                self.containerView.frame = initialFrame
                toView.frame = vcFinalFrame
                transitionView.addSubview(toView)
            }
            subAnimate =  self.subViewAnimate(initialFrame, to: showFrame)
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
extension WQPresentationController : CAAnimationDelegate {
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
extension WQPresentationController : UIGestureRecognizerDelegate {
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
extension WQPresentationController : UIViewControllerTransitioningDelegate {
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

