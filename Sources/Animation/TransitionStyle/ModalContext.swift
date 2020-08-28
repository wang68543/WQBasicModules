//
//  ModalContext.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/8/21.
//

import UIKit

open class ModalContext: NSObject {
    /// 动画时长
    open var duration: TimeInterval = 0.25
    /// 动画结束的时候的View的状态
    open var modalState: ShowState = .readyToShow
    /// 是否正在交互
    open var isInteracting: Bool = false
    
    /// 如果使用Spring动画 就禁止交互动画
    open var isSpring: Bool = false
    /// 是否能够交互
    open var isInteractiveable: Bool = false
    
}
