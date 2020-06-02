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

public extension DispatchQueue {
    /// SwifterSwift: A Boolean value indicating whether the current
    /// dispatch queue is the main queue.
    static var isMainQueue: Bool {
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }
    
    /// SwifterSwift: Returns a Boolean value indicating whether the current
    /// dispatch queue is the specified queue.
    ///
    /// - Parameter queue: The queue to compare against.
    /// - Returns: `true` if the current queue is the specified queue, otherwise `false`.
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }

        return DispatchQueue.getSpecific(key: key) != nil
    }
}
#endif
