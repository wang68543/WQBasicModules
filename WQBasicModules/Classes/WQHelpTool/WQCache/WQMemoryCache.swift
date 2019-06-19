//
//  WQMemoryCache.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/3/1.
//

import Foundation
//class MemeoryObject: NSObject {
//    let value: Any
//    let expiryTime: Double
//
//    init(_ value: Any, expiry: WQCacheExpiry ) {
//        self.value = value
//        self.expiryTime = expiry.expiryTime()
//        super.init()
//    }
//}
class WQCacheEntry<KeyType: Hashable, ValueType: Any> {
    var key: KeyType
    var value: ValueType
    var cost: Int
    var prevByCost: WQCacheEntry?
    var nextByCost: WQCacheEntry?
    
    init(key: KeyType, value: ValueType, cost: Int) {
        self.key = key
        self.value = value
        self.cost = cost
    }
}

class WQCacheKey: NSObject {
    
    var value: AnyHashable
    
    init(_ value: AnyHashable) {
        self.value = value
        super.init()
    }
    
    override var hash: Int {
        return self.value.hashValue
//        switch self.value {
//        case let nsObject as NSObject:
//            return nsObject.hashValue
//        case let hashable as AnyHashable:
//            return hashable.hashValue
//        default: return 0
//        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = (object as? WQCacheKey) else { return false }
        return self.value == other.value
//        if self.value == other.value {
//            return true
//        } else {
//            guard let left = self.value as? NSObject,
//                let right = other.value as? NSObject else { return false }
//
//            return left.isEqual(right)
//        }
    }
}

//参照 NSCache NSCache 不支持协议类型
open class WQMemoryCache<KeyType: Hashable, ValueType: Any>: NSObject {
    
    open var name: String = ""
    open var totalCostLimit: Int = 0 // limits are imprecise/not strict
    open var countLimit: Int = 0 // limits are imprecise/not strict
    
    private var _entries = [WQCacheKey: WQCacheEntry<KeyType, ValueType>]()
    
    private let _lock = NSLock()
    private var _totalCost = 0
    private var _head: WQCacheEntry<KeyType, ValueType>?
    
    public override init() {}
    
//    open weak var delegate: NSCacheDelegate?
    
    open func object(forKey key: KeyType) -> ValueType? {
        var object: ValueType?
        
        let key = WQCacheKey(key)
        
        _lock.lock()
        if let entry = _entries[key] {
            object = entry.value
        }
        _lock.unlock()
        
        return object
    }
    
    open func setObject(_ obj: ValueType, forKey key: KeyType) {
        setObject(obj, forKey: key, cost: 0)
    }
    
    private func remove(_ entry: WQCacheEntry<KeyType, ValueType>) {
        let oldPrev = entry.prevByCost
        let oldNext = entry.nextByCost
        
        oldPrev?.nextByCost = oldNext
        oldNext?.prevByCost = oldPrev
        
        if entry === _head {
            _head = oldNext
        }
    }
    
    private func insert(_ entry: WQCacheEntry<KeyType, ValueType>) {
        guard var currentElement = _head else {
            // The cache is empty
            entry.prevByCost = nil
            entry.nextByCost = nil
            
            _head = entry
            return
        }
        
        guard entry.cost > currentElement.cost else {
            // Insert entry at the head
            entry.prevByCost = nil
            entry.nextByCost = currentElement
            currentElement.prevByCost = entry
            
            _head = entry
            return
        }
        
        while let nextByCost = currentElement.nextByCost, nextByCost.cost < entry.cost {
            currentElement = nextByCost
        }
        
        // Insert entry between currentElement and nextElement
        let nextElement = currentElement.nextByCost
        
        currentElement.nextByCost = entry
        entry.prevByCost = currentElement
        
        entry.nextByCost = nextElement
        nextElement?.prevByCost = entry
    }
    
    open func setObject(_ obj: ValueType, forKey key: KeyType, cost gloabalCost: Int) {
        let gloabal = max(gloabalCost, 0)
        let keyRef = WQCacheKey(key)
        
        _lock.lock()
        
        let costDiff: Int
        
        if let entry = _entries[keyRef] {
            costDiff = gloabal - entry.cost
            entry.cost = gloabal
            
            entry.value = obj
            
            if costDiff != 0 {
                remove(entry)
                insert(entry)
            }
        } else {
            let entry = WQCacheEntry(key: key, value: obj, cost: gloabal)
            _entries[keyRef] = entry
            insert(entry)
            
            costDiff = gloabal
        }
        
        _totalCost += costDiff
        
        var purgeAmount = (totalCostLimit > 0) ? (_totalCost - totalCostLimit) : 0
        while purgeAmount > 0 {
            if let entry = _head {
//                delegate?.cache(unsafeDowncast(self, to: NSCache<AnyObject, AnyObject>.self), willEvictObject: entry.value)
                
                _totalCost -= entry.cost
                purgeAmount -= entry.cost
                
                remove(entry) // _head will be changed to next entry in remove(_:)
                _entries[WQCacheKey(entry.key)] = nil
            } else {
                break
            }
        }
        
        var purgeCount = (countLimit > 0) ? (_entries.count - countLimit) : 0
        while purgeCount > 0 {
            if let entry = _head {
//                delegate?.cache(unsafeDowncast(self, to: NSCache<AnyObject, AnyObject>.self), willEvictObject: entry.value)
                
                _totalCost -= entry.cost
                purgeCount -= 1
                
                remove(entry) // _head will be changed to next entry in remove(_:)
                _entries[WQCacheKey(entry.key)] = nil
            } else {
                break
            }
        }
        
        _lock.unlock()
    }
    
    open func removeObject(forKey key: KeyType) {
        let keyRef = WQCacheKey(key)
        
        _lock.lock()
        if let entry = _entries.removeValue(forKey: keyRef) {
            _totalCost -= entry.cost
            remove(entry)
        }
        _lock.unlock()
    }
    
    open func removeAllObjects() {
        _lock.lock()
        _entries.removeAll()
        
        while let currentElement = _head {
            let nextElement = currentElement.nextByCost
            
            currentElement.prevByCost = nil
            currentElement.nextByCost = nil
            
            _head = nextElement
        }
        
        _totalCost = 0
        _lock.unlock()
    }
}

//public protocol NSCacheDelegate : NSObjectProtocol {
//    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any)
//}
//
//extension NSCacheDelegate {
//    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
//        // Default implementation does nothing
//    }
//}
//public extension WQMemoryCache {
//    subscript<T>(key: String) -> T? {
//        set {
//            self.set(newValue, forKey: key)
//        }
//        get {
//            return self.object(forKey: key)
//        }
//    }
//}
//extension WQMemoryCache {
//    private func cacheKey(forKey key: String) -> NSString {
//        return NSString(string: key)
//    }
//}
