//
//  WQHybridCache.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/3/1.
//

import Foundation
import UIKit
public class WQHybridCache {
    public static let `default` = WQHybridCache()
    
//    public let memoryCache: WQMemoryCache
//    public let diskCache: WQCache
//
//    public init(_ memory: WQMemoryCache? = nil, disk: WQCache? = nil) {
//        if let memoryStorage = memory {
//            memoryCache = memoryStorage
//        } else {
//            memoryCache = WQMemoryCache()
//        }
//        if let diskStorage = disk {
//            diskCache = diskStorage
//        } else {
//            diskCache = WQCache(name: "WQHybridCache", for: .cachesDirectory)
//        }
//    }
//    public func set<T: Encodable>(_ object: T?,
//                                  forKey key: String,
//                                  encoder: JSONEncoder = JSONEncoder(),
//                                  expire: WQCacheExpiry = .never) throws {
//        memoryCache.set(object, forKey: key, expire: expire)
//        try diskCache.set(object, forKey: key, encoder: encoder, expire: expire)
//
//    }
//
//    public func object<T: Decodable>(forKey key: String,
//                                     decoder: JSONDecoder = JSONDecoder()) -> T? {
//        return self.memoryCache.object(forKey: key) ??
//            self.diskCache.object(forKey: key, decoder: decoder)
//    }
}
public extension WQHybridCache {
//    subscript<T: Codable>(key: String) -> T? {
//        set {
//           try? self.set(newValue, forKey: key)
//        }
//        get {
//            return self.object(forKey: key)
//        }
//    }
}
