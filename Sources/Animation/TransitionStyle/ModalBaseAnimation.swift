//
//  ModalBaseAnimation.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2020/9/18.
//

import Foundation
 
public protocol ModalBaseAnimation {
    typealias Completion = (() -> Void)
    func prepare(show manager: TransitionManager, states: WQReferenceStates, completion: @escaping Completion)
    func show(_ manager: TransitionManager, states: WQReferenceStates, completion: @escaping Completion)
    func prepare(hide manager: TransitionManager, states: WQReferenceStates, completion: @escaping Completion)
    func hide(_ manager: TransitionManager, states: WQReferenceStates, completion: @escaping Completion)
}
