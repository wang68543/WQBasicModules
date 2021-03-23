//
//  CustomOperation.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2021/3/23.
//

import UIKit

open class CustomOperation: Operation {
    /// 这里如果支持并发的话 就需要重写下面两个方法
    open override var isAsynchronous: Bool {
        return true
    }
    
    private var _finshed: Bool = false
    open override var isFinished: Bool {
        set {
            guard _finshed != newValue else { return }
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
            guard _executing != newValue else { return }
            self.willChangeValue(forKey: "isExecuting")
            _executing = newValue
            self.didChangeValue(forKey: "isExecuting")
        }
        get {
            return _executing
        }
    }
}
