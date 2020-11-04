//
//  ModalInWindowContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit

public class WQModalContainerWindow: UIWindow {
    
}
public class ModalInWindowContext: ModalDrivenContext {
    lazy var window: WQModalContainerWindow = {
       let win = WQModalContainerWindow()
        return win
    }()
//    override init(_ viewController: WQLayoutController) {
//        super.init(viewController)
//    }
    
//    /// 开始当前的ViewController转场动画
//    /// - Parameters:
//    ///   - viewController: 主要用于转场动画 snapshot
//    public func show(in viewController: UIViewController?, animated flag: Bool, completion: ModalContext.Completion? = nil) {
//        super.show(in: viewController, animated: flag, completion: completion)
//    }
}
