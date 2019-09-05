//
//  TransitionAnimateContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/5.
//

import Foundation
public protocol TransitionAnimateContext: NSObjectProtocol {
     
    func transitionCancel(_ isInteractive: Bool)
    func transitionPause()
    func transitionUpdate(_ percentComplete: CGFloat)
    func transitionFinish(_ isInteractive: Bool)
}
//open class TransitionAnimateContext {
//    var duration: TimeInterval = 0.0
//    func prepare() {
//
//    }
//    func pause() {
//
//    }
//    func update(_ percentComplete: CGFloat) {
//
//    }
//
//    func cancel(_ isInteractive: Bool) {
//        //        fractionComplete = 0.0
//    }
//
//    func finish(_ isInteractive: Bool) {
//        //        fractionComplete = 1.0
//    }
//}
