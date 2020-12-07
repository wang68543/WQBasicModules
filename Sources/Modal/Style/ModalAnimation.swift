//
//  TransitionAnimationPreprocessor.swift
//  Pods
//
//  Created by WQ on 2019/9/6.
//

import Foundation
@available(iOS 10.0, *)
public protocol ModalAnimation: class {
    typealias Completion = (() -> Void)
    
    var duration: TimeInterval { get set }
    /// 是否可以动画
    var animationEnable: Bool { get set }
    /// 是否是正在交互中
    var isInteractive: Bool { get set }
    
    func preprocessor(_ state: ModalState,
                      layoutController: WQLayoutController, 
                      states: StyleConfig,
                      completion: Completion?) 
}
