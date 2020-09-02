//
//  ModalInParentContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit

open class ModalInParentContext: ModalDrivenContext {
//   weak var parent: UIViewController?
//    public override init(_ viewController: WQLayoutContainerViewController) {
//        guard let fatherViewController = fromViewController ?? wm_topVisibleViewController() else {
//                  fatalError("未找到当前正在显示的ViewController")
//              }
//         parent = fatherViewController
//        super.init(viewController)
//    }
    
    /// 开始当前的ViewController转场动画
    /// - Parameters:
    ///   - viewController: 若为nil 查找当前正在显示的最顶层的ViewController
    ///     viewController 可为TabBarViewController或NavigationViewController
    open override func show(in viewController: UIViewController?, animated flag: Bool, completion: ModalContext.Completion? = nil) {
        super.show(in: viewController, animated: flag, completion: completion)
        
    }
   
}
