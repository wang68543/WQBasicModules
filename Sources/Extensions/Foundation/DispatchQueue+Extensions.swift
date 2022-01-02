//
//  DispatchQueue+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/10/16.
//

#if canImport(Dispatch)
import Dispatch

/// 仿oc版gcd延时 
public func dispatch_main_after(_ interval: TimeInterval, execute: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval, execute: execute)
}
/// 主线程执行
public func dispatch_main_async(execute: @escaping (() -> Void)) {
    DispatchQueue.main.async(execute: execute)
}
public extension DispatchQueue {
    /// 简化延迟方法执行
    func after(_ interval: TimeInterval, execute: @escaping (() -> Void)) {
        self.asyncAfter(deadline: DispatchTime.now() + interval, execute: execute)
    }
}
#endif
