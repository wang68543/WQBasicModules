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
    func didViewLoad(_ controller: WQLayoutController)
    func show(_ controller: WQLayoutController, animated flag: Bool, completion: TransitionAnimation.Completion?)
    func hide(_ controller: WQLayoutController, animated flag: Bool, completion: TransitionAnimation.Completion?) -> Bool
//    optional func update(_ controller: WQLayoutController, progress: CGFloat) 
}

public class WQLayoutController: UIViewController {
    // viewWillAppear viewWillDisappear viewDidDisappear
    public var lifeCycleable: Bool = false
     
    public lazy var manager: TransitionManager = {
       return TransitionManager(config, states: statesConfig, layout: self)
    }()
    let config: ModalConfig
    let statesConfig: TransitionStatesConfig
    public init(_ config: ModalConfig, states: TransitionStatesConfig) {
        self.config = config
        self.statesConfig = states
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    internal func setup() {
        self.view.addSubview(dimmingView)
        self.dimmingView.isOpaque = false
        self.view.addSubview(self.container)
    }
     
    public override func viewDidLoad() {
        super.viewDidLoad()
        manager.didViewLoad(self)
        
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dimmingView.frame = self.view.bounds 
        
    }
    public func modal(_ flag: Bool, comletion: TransitionAnimation.Completion? = nil) {
        manager.show(self, animated: flag, completion: comletion)
    }
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        let superDismiss = self.manager.hide(self, animated: flag, completion: completion)
        if superDismiss == true  {
            super.dismiss(animated: flag, completion: completion)
        }  
    }
    
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
    
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if WDEBUG
        debugPrint("\(self):" + #function + "♻️")
        #endif
    } 
}
 
