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
public protocol WQLayoutControllerTransition: NSObjectProtocol {
//    func didViewLoad(_ controller: WQLayoutController)
    func show(_ controller: WQLayoutController, statesConfig: StyleConfig, completion: TransitionAnimation.Completion?)
    func hide(_ controller: WQLayoutController, animated flag: Bool, completion: TransitionAnimation.Completion?) -> Bool
//    optional func update(_ controller: WQLayoutController, progress: CGFloat) 
}

public class WQLayoutController: UIViewController {
    // viewWillAppear viewWillDisappear viewDidDisappear
    public var lifeCycleable: Bool = false 
    public var context: ModalContext?
    
    public let config: ModalConfig
    public var statesConfig: StyleConfig?
    
    public init(_ config: ModalConfig, subView: UIView) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        setup()
        self.container.addSubview(subView)
    }
    
    internal func setup() { 
        self.view.addSubview(dimmingView)
//        self.dimmingView.isOpaque = false 
        self.view.addSubview(self.container)
    }
    lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        return gesture
    }()
    
    lazy var panGesture: PanDirectionGestureRecongnizer = {
        let gesture = PanDirectionGestureRecongnizer(target: self, action: #selector(panGestureAction(_:)))
        return gesture
    }()
    @objc func tapGestureAction(_ gseture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func panGestureAction(_ gesture: PanDirectionGestureRecongnizer) {
        
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.addGesture()
    }
    
    private func addGesture() {
        switch self.config.interactionDismiss {
        case .tapAll:
            self.view.addGestureRecognizer(tapGesture)
        case .tapOutSide:
            tapGesture.delegate = self
            self.view.addGestureRecognizer(tapGesture)
        case let .pan(direction):
            panGesture.direction = direction
            self.view.addGestureRecognizer(panGesture)
            break
        default:
            break
        }
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dimmingView.frame = self.view.bounds 
        
    }
    public func modal(_ states: StyleConfig, comletion: TransitionAnimation.Completion? = nil) {
//        let sConfig = self.setupStates(states)
        statesConfig = states
        states.setupStates(self)
        context = ModalContext.modalContext(self.config, states: states)
        
        context?.show(self, statesConfig: states, completion: comletion)
    }
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let ctx = context {
            if ctx.hide(self, animated: flag, completion: completion) == false {
                super.dismiss(animated: flag, completion: completion)
            }
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
       
    }
    
    // MARK: -- -UI属性
    internal lazy var dimmingView: UIView = {
       let diming = UIView()
        diming.isUserInteractionEnabled = false
        diming.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        diming.alpha = 0.0
        return diming
    }()
    
    /// 转场容器View
    public lazy var container: WQContainerView = {
       let transitionView = WQContainerView()
        transitionView.backgroundColor = UIColor.clear
        return transitionView
    }()
    
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if WDEBUG
        debugPrint("\(self):" + #function + "♻️")
        #endif
    } 
}
extension WQLayoutController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let tap = gestureRecognizer as? UITapGestureRecognizer,
              tap == self.tapGesture else {
            return true
        }
        let point = tap.location(in: self.view)
        return !self.container.frame.contains(point)
    }
}
//public extension WQLayoutController {
//
//    func setupStates(_ statesConfig: TransitionStatesConfig) -> TransitionStatesConfig  {
////        var states: [ModalState: WQReferenceStates] = [:]
//        switch statesConfig.showStyle {
//            case .alert:
////                var willShowStates: WQReferenceStates = [:]
//
//                let dimalpha = TSReferenceValue(value: 0.0, keyPath: \WQLayoutController.dimmingView.alpha)
//                let conataineralpha = TSReferenceValue(value: 0.0, keyPath: \WQLayoutController.container.alpha)
//
//                let controllerSize = statesConfig.showControllerFrame.size
//                let size = self.container.sizeThatFits()
//
//                let containerFrame = CGRect(x: (controllerSize.width - size.width)*0.5, y: (controllerSize.height - size.height)*0.5, width: size.width, height: size.height)
//                let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//                let refrenceTransform = TSReferenceTransform(value: transform, keyPath: \WQLayoutController.container.transform)
//                let refrenceFrame = TSReferenceRect(value: containerFrame, keyPath: \WQLayoutController.container.frame)
////                willShowStates.addState(self, [dimalpha,conataineralpha, refrenceFrame, refrenceTransform])
//                statesConfig.addState(self, value: dimalpha, state: .willShow)
//                statesConfig.addState(self, value: conataineralpha, state: .willShow)
//                statesConfig.addState(self, value: refrenceFrame, state: .willShow)
//                statesConfig.addState(self, value: refrenceTransform, state: .willShow)
////
//                let showDimalpha = TSReferenceValue(value: 1.0, keyPath: \WQLayoutController.dimmingView.alpha)
//                let showConataineralpha = TSReferenceValue(value: 1.0, keyPath: \WQLayoutController.container.alpha)
//
//                let showTransform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//                let showRefrenceTransform = TSReferenceTransform(value: showTransform, keyPath: \WQLayoutController.container.transform)
//
//                statesConfig.addState(self, value: showDimalpha, state: .show)
//                statesConfig.addState(self, value: showConataineralpha, state: .show)
//                statesConfig.addState(self, value: showRefrenceTransform, state: .show)
//
//                let didShowTransform = CGAffineTransform.identity
//                let didShowRefrenceTransform = TSReferenceTransform(value: didShowTransform, keyPath: \WQLayoutController.container.transform)
//                statesConfig.addState(self, value: didShowRefrenceTransform, state: .didShow)
//
//                statesConfig.addState(self, value: dimalpha, state: .hide)
//                statesConfig.addState(self, value: conataineralpha, state: .hide)
//                statesConfig.addState(self, value: refrenceTransform, state: .hide)
//
//
//            case .actionSheet:
//                break
//            default:
//                break
//            }
//            return statesConfig
//    }
//}
