//
//  TransitionAnimator.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/2.
//

import UIKit
@available(iOS 10.0, *)
open class TransitionAnimator: NSObject {
    /// newWindowRoot的时候 记录的属性 用于消失之后恢复
    internal weak var previousKeyWindow: UIWindow?
    //用于容纳当前控制器的window窗口
    internal var window: WQTransitionWindow?
    
//    public internal(set) var fractionComplete: CGFloat = 0.0
    
    /// 动画时长
//    open var propertyAnimator: UIViewPropertyAnimator
    
//    open var showAnimationBlock: ()
    
//    open var animationBlock: (() -> Void)? {
//        didSet {
//            if let block = animationBlock {
//                self.propertyAnimator.addAnimations(block)
//            }
//        }
//    }
    
//    open var completionBlock: ((Bool) -> Void)? {
//        didSet {
//            if let block =  completionBlock {
//                self.propertyAnimator.addCompletion(<#T##completion: (UIViewAnimatingPosition) -> Void##(UIViewAnimatingPosition) -> Void#>)
//            }
//        }
//    }
    
    //UISpringTimingParameters UICubicTimingParameters
//    public init(_ duration: TimeInterval, timingParameters parameters: UITimingCurveProvider) {
//        self.propertyAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: parameters)
//        super.init()
//    }
    
}
@available(iOS 10.0, *)
extension TransitionAnimator {
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
