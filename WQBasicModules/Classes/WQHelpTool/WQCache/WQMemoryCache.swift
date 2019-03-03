//
//  WQMemoryCache.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/3/1.
//

import Foundation
class MemeoryObject: NSObject {
    let value: Any
    let expiryTime: Double
    
    init(_ value: Any, expiry: WQCacheExpiry ) {
        self.value = value
        self.expiryTime = expiry.expiryTime()
        super.init()
    }
}
public class WQMemoryCache {
    public static let shared = WQMemoryCache()
    /// 线程安全的 当内存不足的时候自动释放
    let cache: NSCache<NSString, MemeoryObject> = NSCache()
    // Default 100M
    public init(_ countLimit: Int = 0, totalCostLimit: Int = 104_857_600) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit
    }
    
    public func object<T>(forKey key: String) -> T? {
        return self.cache.object(forKey: NSString(string: key))?.value as? T
    }
    public func set<T>(_ obj: T?, forKey key: String, expire: WQCacheExpiry = .never) {
        let cacheKey = self.cacheKey(forKey: key)
        if let value = obj {
            self.cache.setObject(MemeoryObject(value, expiry: expire), forKey: cacheKey)
        } else {
            self.cache.removeObject(forKey: cacheKey)
        }
    }
    
    public func remove(forKey key: String) {
        self.cache.removeObject(forKey: NSString(string: key))
    }
    public func removeAll() {
        self.cache.removeAllObjects()
    }
}
public extension WQMemoryCache {
    subscript<T>(key: String) -> T? {
        set {
            self.set(newValue, forKey: key)
        }
        get {
            return self.object(forKey: key)
        }
    }
}
extension WQMemoryCache {
    private func cacheKey(forKey key: String) -> NSString {
        return NSString(string: key)
    }
}
