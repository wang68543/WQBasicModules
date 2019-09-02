//
//  TransitionAnimator.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/2.
//

import UIKit
open class TransitionAnimator: NSObject {
    /// newWindowRoot的时候 记录的属性 用于消失之后恢复
    internal weak var previousKeyWindow: UIWindow?
    //用于容纳当前控制器的window窗口
    internal var window: WQTransitionWindow?
    
    public internal(set) var fractionComplete: CGFloat = 0.0
    
    /// 动画时长 
    open var duration: TimeInterval = 0.25
    
}
extension TransitionAnimator {
    @available(iOS 10.0, *)
    func pause() {
        
    }
    func update(_ percentComplete: CGFloat) {
        
    }
    
    func cancel() {
        //        fractionComplete = 0.0
    }
    
    func finish() {
        //        fractionComplete = 1.0
    }
}
