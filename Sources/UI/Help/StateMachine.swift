//
//  StateMachine.swift
//  Pods
//
//  Created by 王强 on 2021/1/19.
//

import Foundation
public protocol StateMachineDataSource {
    func shouldTransition(from: Self, to: Self) -> Bool
}

public protocol StateMachineDelegate: class {
    associatedtype StateType: StateMachineDataSource
    func didTransition(from: StateType, to: StateType)
}

public class StateMachine<P: StateMachineDelegate> {
    private var _state: P.StateType {
        didSet {
            delegate.didTransition(from: oldValue, to: _state)
        }
    }
    
    public var state: P.StateType {
        get {
            return _state
        }
        set {
            guard _state.shouldTransition(from: _state, to: newValue) else {
                return
            }
            _state = newValue
        }
    }
    
    public var delegate: P
    
    public init(initialState: P.StateType, delegate: P) {
        _state = initialState
        self.delegate = delegate
    }
}


/**
 示例
 public enum LoginState: Int, StateMachineDataSource {
     case unlogin
     case logedin
     case expired
     public func shouldTransition(from: LoginState, to: LoginState) -> Bool {
         switch (from, to) {
         case (.unlogin, .logedin):
             return true
         default:
             return true
         }
     }
 }

 public class LoginStateMachineDelegate: StateMachineDelegate {
     // subject
     
     public typealias StateType = LoginState
     
     public func didTransition(from: LoginState, to: LoginState) {
         // 发送通知
     }
 }

 final class LoginStateMachine {
     static let `defalut` = StateMachine<LoginStateMachineDelegate>(
         initialState: .unlogin, delegate: LoginStateMachineDelegate()
     )
 }
 */
