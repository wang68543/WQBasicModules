//
//  TransitionProperty.swift
//  Pods
//
//  Created by WQ on 2019/9/4.
//

import Foundation
//public protocol TransitionPropertyProtocol {
//        
//    
//}
//open class TransitionProperty<Root, Value> { /// 用于使用默认参数的转场动画
//    public enum State {
//        case initial
//        case show
//        case hiden
//    }
//    
//    public enum Source {
//        case toShow
//        case presentShow
//        case addition(TransitionProperty)
//    }
//    
//    let keyPath: ReferenceWritableKeyPath<Root, Value>
//    let value: Value
//    let state: State
//    
//    let source: Source
////    let isAddition: Bool
//    public init(_ state: State,
//                keyPath: ReferenceWritableKeyPath<Root, Value>,
//                value: Value,
//                source: Source) {
//        self.keyPath = keyPath
//        self.value = value
//        self.state = state
//        self.source = source
//    }
//    /// 配置
//    func set(for instance: Any) {
//        guard let element = instance as? Root else {
//            return
//        }
////        switch source {
////        case .addition(element):
////             self.get(with: element)
////        default:
////            <#code#>
////        }
//        element[keyPath: keyPath] = value
//    }
//    /// 修改
//    func get(with instance: Any) -> Value? {
//        guard let element = instance as? Root else {
//            return nil
//        }
//        return element[keyPath: keyPath]
//    }
//}
