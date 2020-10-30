//
//  WQLayoutContainerViewController.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit


/**
 将当前控制器的View 作为transitionView 
 */
public protocol WQLayoutControllerDelegate: NSObjectProtocol {
    func didViewLoad(_ controller: WQLayoutController)
    func show(_ controller: WQLayoutController, animated flag: Bool, completion: WQLayoutController.Completion?)
    func hide(_ controller: WQLayoutController, animated flag: Bool, completion: WQLayoutController.Completion?) -> Bool
}
public class WQLayoutController: UIViewController {
    public typealias Completion = (() -> Void)
    // viewWillAppear viewWillDisappear viewDidDisappear
    public var lifeCycleable: Bool = false
    
//    public lazy var manager = TransitionManager()
    weak var delegate: WQLayoutControllerDelegate?
//    public lazy var modalManager: TransitionManager = {
//       return TransitionManager(self)
//    }()
    
//    public var modalContext: ModalContext?
      
    internal func setup() {
        self.view.addSubview(dimmingView)
        self.dimmingView.isOpaque = false
        self.view.addSubview(self.container)
    }
     
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate?.didViewLoad(self)
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dimmingView.frame = self.view.bounds 
        
    }
//    public override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//
//    }
    public func modal(animated flag: Bool, completion: WQLayoutController.Completion? = nil) {
        self.delegate?.show(self, animated: flag, completion: completion)
    }
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        let superDismiss = self.delegate?.hide(self, animated: flag, completion: completion)
        if superDismiss == true  {
            super.dismiss(animated: flag, completion: completion)
        }  
    }
    
//    /// 这里的尺寸是跟随父View的尺寸的
//    public func show(in viewController: UIViewController?, animated flag: Bool, completion: (() -> Void)? = nil) {
//
//    }
//
//    public func show(withSystemPrensention presenter: UIViewController?, animated flag: Bool, completion: (() -> Void)? = nil) {
//        let viewController = presenter ?? wm_topVisibleViewController()
//        self.show(fromViewController: viewController, animated: flag, style: .modalSystem, completion: completion)
//    }
//    public func show(inWindow fromViewController: UIViewController?, animated flag: Bool, completion: (() -> Void)? = nil) {
//        let viewController = fromViewController ?? wm_topVisibleViewController()
//        self.show(fromViewController: viewController, animated: flag, style: .modalInWindow, completion: completion)
//    }
//    public func show(inParent parentViewController: UIViewController?, animated flag: Bool, completion: (() -> Void)? = nil) {
//        guard let fromViewController = parentViewController ?? wm_topVisibleViewController() ?? UIApplication.shared.keyWindow?.rootViewController else {
//            fatalError("当前没有可显示的窗口")
//        }
//        self.show(fromViewController: fromViewController, animated: flag, style: .modalInParent, completion: completion)
//    }
//
//    private func show(fromViewController: UIViewController?, animated flag: Bool, style: ModalStyle, completion: (() -> Void)? = nil) {
//        if modalContext == nil { modalContext =  ModalContext.modalContext(with: self, modalStyle: style) }
//        modalContext?.show(in: fromViewController, animated: flag, completion: completion)
//    }
    
    
    // MARK: -- -UI属性
    internal lazy var dimmingView: UIView = {
       let diming = UIView()
        diming.isUserInteractionEnabled = false
        diming.backgroundColor = UIColor.black
        diming.alpha = 0.0
        return diming
    }()
    
    /// 转场容器View
    public lazy var container: WQContainerView = {
       let transitionView = WQContainerView()
        transitionView.backgroundColor = UIColor.clear
        return transitionView
    }()
    
    // MARK: -- -init
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if WDEBUG
        debugPrint("\(self):" + #function + "♻️")
        #endif
    }
    
}

//public extension WQLayoutController {
//    static let container: TSReferenceWriteable
//}
public class WQContainerView: UIView {
    public override func addSubview(_ view: UIView) {
        super.addSubview(view)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        guard let subView = self.subviews.first else { return }
//        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////        subView.bounds = self.bounds
////        let anchorPoint = subView.layer.anchorPoint
////        subView.center = CGPoint(x: anchorPoint.x * self.bounds.width, y: anchorPoint.y * self.bounds.height)
//    }
}
