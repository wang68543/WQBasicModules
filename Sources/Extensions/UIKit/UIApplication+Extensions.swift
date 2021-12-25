//
//  UIApplication+Extensions.swift
//  Pods
//
//  Created by WQ on 2019/6/21.
//
import Foundation
public extension UIApplication {
    var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? String() 
    }
} 
