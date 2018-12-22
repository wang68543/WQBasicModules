//
//  WQPresentCenterController.swift
//  Pods-WQBasicModules_Example
//
//  Created by WangQiang on 2018/12/15.
//

import UIKit

open class WQPresentCenterController: WQPresentationController {
    public init(_ subView: UIView, size: CGSize, presentedFrame: CGRect = UIScreen.main.bounds) {
//        super.init(transitionType: subView, size: size, initial: .bottom, show: .center, dismiss: .top)
        super.init(position: subView, show: .center, size: size, bounceType: .horizontalMiddle, presentedFrame: presentedFrame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
