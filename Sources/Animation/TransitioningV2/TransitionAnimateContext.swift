//
//  TransitionAnimateContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2019/9/5.
//

import Foundation
public protocol TransitionAnimateContext: NSObjectProtocol {
     
    func transitionCancel()
    func transitionPause()
    func transitionUpdate(_ percentComplete: CGFloat)
    func transitionFinish()
}
