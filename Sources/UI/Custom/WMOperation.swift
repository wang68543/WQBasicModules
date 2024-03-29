//
//  WMOperation.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2021/3/23.
//

import UIKit

open class WMOperation: Operation {
    /// 这里如果支持并发的话 就需要重写下面两个方法
    open override var isAsynchronous: Bool {
        return true
    }

    private var _finshed: Bool = false
    open override var isFinished: Bool {
        set {
            self.willChangeValue(forKey: "isFinished")
            _finshed = newValue
            self.didChangeValue(forKey: "isFinished")
        }
        get {
            return _finshed
        }
    }
    private var _executing: Bool = false
//    A Boolean value indicating whether the operation is currently executing.
    open override var isExecuting: Bool {
        set {
            self.willChangeValue(forKey: "isExecuting")
            _executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
        get {
            return _executing
        }
    }
    open override func start() {
        super.start()
        guard !self.isCancelled else { return }
        self.isExecuting = true
    }
    open override func cancel() {
        super.cancel()
        self.complete()
    }
    open func complete() {
        self.isExecuting = false
        self.isFinished = true
    }

}
