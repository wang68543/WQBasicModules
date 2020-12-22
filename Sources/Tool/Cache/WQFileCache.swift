//
//  WQFileCache.swift
//  Pods
//
//  Created by 王强 on 2020/12/8.
//

import Foundation
import UIKit
public class WQFileCache: NSObject {
    lazy var ioQueue: DispatchQueue = {
        let attrs = DispatchQueue.Attributes.concurrent
        let queue = DispatchQueue(label: "rwOptions", qos: DispatchQoS.background, attributes: attrs)
        return queue
    }()
    //读写锁
    private lazy var lock: pthread_rwlock_t = pthread_rwlock_t()
    
    public let directory: URL
    
    public init(_ directory: URL) {
        self.directory = directory
        super.init()
        var isDirectory: ObjCBool = false
        let fileExists = FileManager.default.fileExists(atPath: directory.path, isDirectory: &isDirectory)
        if !fileExists || !isDirectory.boolValue {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    deinit {
        pthread_rwlock_destroy(&lock)
    }
}
//public class WQArchive {
//    let ioQueue: DispatchQueue = {
//        let attrs = DispatchQueue.Attributes.concurrent
//        let queue = DispatchQueue(label: "rwOptions", qos: DispatchQoS.background, attributes: attrs)
//        return queue
//    }()
//    
//    func set(_ value: Encodable, forKey key: String) throws {
//        
//    }
//    func syncSet(_ value: Encodable, forKey key: String) throws {
//        
//    }
//    func object<T: Decodable>(forKey key: String) throws -> T {
//        let data = try self.read(forKey: key)
//        return try T.model(from: data)
//    }
//}
//public extension WQArchive {
//    func save(_ data: Data, forKey key: String) throws {
//        
//    }
//    func read(forKey key: String) throws -> Data {
//        
//    }
//}
