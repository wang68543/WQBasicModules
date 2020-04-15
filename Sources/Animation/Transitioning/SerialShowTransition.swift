//
//  SerialShowTransition.swift
//  Pods
//
//  Created by iMacHuaSheng on 2020/4/15.
//

import Foundation
public protocol SerialShowTransition {
    func willShow()
    func didShow()
    func willDismiss()
    func didDismiss()
}
