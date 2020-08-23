//
//  WQLayoutContainerViewController.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit

public class WQLayoutContainerViewController: UIViewController {
    
    // viewWillAppear viewWillDisappear viewDidDisappear
    public var shouldEnableLifecycle: Bool = false
    
    
    lazy var modalContext: ModalContext = {
       return ModalContext()
    }()
    

  
    
    internal func setup() {
        self.view.addSubview(dimmingView)
        self.dimmingView.isOpaque = false
        self.view.addSubview(self.layoutTransitionView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dimmingView.frame = self.view.bounds
    }
    
    
//    public func modal()
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
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
    internal lazy var layoutTransitionView: WQContainerView = {
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
    
}

//extension WQLayoutContainerViewController {
//    @objc func tapBackgroundAction(_ tapGR: UITapGestureRecognizer) {
//
//    }
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
