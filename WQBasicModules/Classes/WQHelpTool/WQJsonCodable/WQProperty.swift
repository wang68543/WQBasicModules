//
//  WQProperty.swift
//  WQJsonModule
//
//  Created by hejinyin on 2018/3/7.

import Foundation

///为了 集合C与API的兼容swift为指针访问设计了一套家族类型以求在编写代码的时候就明确表达自己的访问意图
/// 5个关键词 就像开关
/// Managed 表示指针指向的类型是受托管的 编译器会为我们处理内存的分配、初始化、回收
/// 当给一个受ARC托管的对象赋值的时候 运行时会先释放老的对象再将变量指向新的对象 (而当老的对象是垃圾值的时候 就会出现运行时错误)
// UnSafed  申请资源、init 、deinit、资源回收 都需要自己管理
// Buffer

// Raw 没有类型信息 相当于 c中的 (void *)
// Mutable

// Pointer
// OpaquePointer
public enum WQPropertyStyle {
    
        case unknown
    
        case `struct`
        
        case `class`
        
        case `enum`
        
        case tuple
        
        case optional
        
        case collection
        
        case dictionary
        
        case set
 
    init(_ mirrorStyle: Mirror.DisplayStyle) {
        switch mirrorStyle {
        case .`struct`:
            self = .`struct`
        case .class:
            self = .`class`
        case .`enum`:
            self = .`enum`
        case .tuple:
            self = .tuple
        case .optional:
            self = .optional
        case .collection:
            self = .collection
        case .dictionary:
            self = .dictionary
        case .set:
            self = .set
        }
    }
}
public struct WQProperty {
    //实例名称
    var name: String
    //实例类型
    var type: Any.Type
    //数据属于数据的类型
    var displayStyle: WQPropertyStyle
    //在内存中占据的字节数
    var memorySize: Int
    
    //下属属性的类型
    var subProperties: [WQProperty]?
    
    init(name label: String, value: Any, subProperties: [WQProperty]?) {
         let mirror = Mirror(reflecting: value)
        name = label
        type = mirror.subjectType
        if let style = mirror.displayStyle {
            displayStyle = WQPropertyStyle(style)
        } else {
            displayStyle = WQPropertyStyle.unknown
        }
        
        self.subProperties = subProperties
        //如果这里值为空
        memorySize = MemoryLayout.size(ofValue: value)
    }
    static public func properties(for instance: Any) -> [WQProperty] {
        var properties: [WQProperty] = []
        let current = Mirror(reflecting: instance)
        
        if let displayStyle = current.displayStyle {
//            switch displayStyle {
//            case .`class`:
//            case .`struct`:
//            case .`enum`:
//            case .tuple:
//            case .optional:
//            case .collection:
//            case .dictionary:
//            case .set:
//            }
            
        } else {//displayStyle 为nil 表示基本数据类型
            //
        }
        // 当for case 组合使用的时候 这里的问号 起到解包作用
        for case let (label?, value) in current.children {
          let mirror = Mirror(reflecting: value)
            var subProperties: [WQProperty]?
            if mirror.displayStyle == Mirror.DisplayStyle.dictionary || mirror.displayStyle == Mirror.DisplayStyle.tuple {
                subProperties = nil
            } else {
                subProperties = WQProperty.properties(for: value)
            }
            let property = WQProperty(name: label, value: value, subProperties: subProperties)
             properties.append(property)
            }
        return properties
        
    }
}
