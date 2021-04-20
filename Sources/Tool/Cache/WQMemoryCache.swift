//
//  WQMemoryCache.swift
//  Pods
//
//  Created by HuaShengiOS on 2019/3/1.
//

import Foundation
class WQCacheEntry<ValueType: Any> { 
    var value: ValueType
    var cost: Int
    var prevByCost: WQCacheEntry?
    var nextByCost: WQCacheEntry?
    
    init(value: ValueType, cost: Int) {
        self.value = value
        self.cost = cost
    }
}
//参照 NSCache NSCache 不支持协议类型
open class WQMemoryCache<ValueType: Any>: NSObject {
    typealias CacheKeyType = AnyHashable
    
    open var name: String = ""
    open var totalCostLimit: Int = 0 // limits are imprecise/not strict
    open var countLimit: Int = 0 // limits are imprecise/not strict
    
    private var _entries = [CacheKeyType: WQCacheEntry<ValueType>]()
    
    private let _lock = NSLock()
    private var _totalCost = 0
    private var _head: WQCacheEntry<ValueType>?
    
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveMemoryWarning),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    open weak var delegate: NSCacheDelegate?
    @objc
    func didReceiveMemoryWarning() {
        self.removeAllObjects()
    }
    open func object(forKey key: AnyHashable) -> ValueType? {
        var object: ValueType?
        
        _lock.lock()
        if let entry = _entries[key] {
            object = entry.value
        }
        _lock.unlock()
        
        return object
    }
    
    open func setObject(_ obj: ValueType, forKey key: AnyHashable) {
        setObject(obj, forKey: key, cost: 0)
    }
    
    private func remove(_ entry: WQCacheEntry<ValueType>) {
        let oldPrev = entry.prevByCost
        let oldNext = entry.nextByCost
        
        oldPrev?.nextByCost = oldNext
        oldNext?.prevByCost = oldPrev
        
        if entry === _head {
            _head = oldNext
        }
    }
    
    private func insert(_ entry: WQCacheEntry<ValueType>) {
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
    
    open func setObject(_ obj: ValueType, forKey key: AnyHashable, cost gloabalCost: Int) {
        let gloabal = max(gloabalCost, 0)
//        let keyRef = WQCacheKey(key)
        let keyRef = key
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
            let entry = WQCacheEntry(value: obj, cost: gloabal)
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
                _entries[key] = nil
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
                _entries[key] = nil
            } else {
                break
            }
        }
        
        _lock.unlock()
    }
    
    open func removeObject(forKey key: AnyHashable) {
        _lock.lock()
        if let entry = _entries.removeValue(forKey: key) {
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
    
    subscript(key: AnyHashable) -> ValueType? {
        set {
            if let value = newValue {
               self.setObject(value, forKey: key)
            } else {
                self.removeObject(forKey: key)
            }
        }
        get {
            self.object(forKey: key)
        }
    }
}
//extension WQMemoryCache {
//
//}
//public protocol NSCacheDelegate : NSObjectProtocol {
//    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any)
//}
//
//extension NSCacheDelegate {
//    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
//        // Default implementation does nothing
//    }
//} 
