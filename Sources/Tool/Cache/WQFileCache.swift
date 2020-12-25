//
//  WQFileCache.swift
//  Pods
//
//  Created by 王强 on 2020/12/8.
//

import Foundation
import UIKit
public class WQFileCache: NSObject {
    static let shared: WQFileCache = {
       var url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
       url.appendPathComponent("FileSharedCaches")
       return WQFileCache(url)
    }()
    
    lazy var ioQueue: DispatchQueue = {
        let attrs = DispatchQueue.Attributes.concurrent
        let queue = DispatchQueue(label: "rwOptions", qos: DispatchQoS.background, attributes: attrs)
        return queue
    }()
    //读写锁
//    private lazy var lock: pthread_rwlock_t = pthread_rwlock_t()
    
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
    public func url(for name: String) -> URL {
        let key = name.sha1String(lower: true)
        return directory.appendingPathComponent(key)
    }
    public func write(_ data: Data, for name: String, synchronize: Bool) throws {
        let url = self.url(for: name)
        if synchronize {
            ioQueue.async {
                try? data.write(to: url, options: .atomic)
            }
        } else {
            try data.write(to: url, options: .atomic)
        }
    }
    public func read(for name: String) -> Data? {
        let path = self.url(for: name).path
        return FileManager.default.contents(atPath: path)
    }
//    deinit {
//        pthread_rwlock_destroy(&lock)
//    }
}
public extension WQFileCache {
    func save(_ value: Encodable, for name: String, synchronize: Bool) throws {
        guard let data = try? value.toJSON() else { return }
        try write(data, for: name, synchronize: synchronize)
    }
    func value<T: Decodable>(for name: String) -> T? {
        guard let data = read(for: name) else { return nil }
        return try? T.model(from: data)
    }
}
public extension WQFileCache {
    
    func archiver(_ value: NSCoding, for name: String, synchronize: Bool) throws {
        if !synchronize {
            if #available(iOS 11.0, *) {
                let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
                try self.write(data, for: name, synchronize: synchronize)
            } else {
                let path = self.url(for: name).path
                NSKeyedArchiver.archiveRootObject(value, toFile: path)
            }
        } else {
            ioQueue.async {
                if #available(iOS 11.0, *) {
                    if let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) {
                        try? self.write(data, for: name, synchronize: synchronize)
                    }
                } else {
                    let path = self.url(for: name).path
                    NSKeyedArchiver.archiveRootObject(value, toFile: path)
                }
            }
        }
    }
    
    func unarchiver(ofClasses classes: Set<AnyHashable>, for name: String) -> Any? {
        guard let data = self.read(for: name) else { return nil }
        if #available(iOS 11.0, *) {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: classes, from: data)
        } else {
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        }
    }
}
