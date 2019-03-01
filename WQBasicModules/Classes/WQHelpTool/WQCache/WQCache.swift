//
//  WQCache.swift
//  WQBasicModules
//
//  Created by WangQiang on 2018/9/19.
//

import UIKit

public class WQCache {
    public static let didReceiveCacheMemoryWarning = NSNotification.Name("didReceiveCacheMemoryWarning")
    //  "wq.defaultCache.disk.com"
    public static let `default` = WQCache(name: "defaultCache", for: .cachesDirectory)
    
    public let baseDirectory: URL
    public let fileManager: FileManager
    //读写锁
    private var lock: pthread_rwlock_t
    private let ioQueue: DispatchQueue
    /// 根据路径创建存储实例
    ///
    /// - Parameters:
    ///   - url: 存储文件夹(需是app路径下面的二级目录)
    ///   - fileManager: 文件管理器
    private init(_ directory: URL, fileManager: FileManager = .default) { //后面需新增内存存储
        var path = directory
        path.deleteLastPathComponent()
        path = path.appendingPathComponent("wq.disk.cache.com", isDirectory: true)
            .appendingPathComponent(directory.lastPathComponent)
        self.baseDirectory = path
        self.fileManager = fileManager
        if !fileManager.fileExists(atPath: path.path) {
            do {
                try fileManager.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                debugPrint("创建文件夹失败", error.localizedDescription)
            }
        }
        lock = pthread_rwlock_t()
        ioQueue = DispatchQueue(label: "rwOptions") 
    }
    
    public func fileExists(_ key: String) -> Bool {
        return fileManager.fileExists(atPath: self.path(for: key).path)
    }
    
    /// 异步存储数据
    ///
    /// - Parameters:
    ///   - completion: 存储完成回调
    public func asyncSet<T: Encodable>(_ object: T?,
                                       forKey key: String,
                                       expire: WQCacheExpiry = .never,
                                       completion: ((Error?) -> Void)? = nil) {
        ioQueue.async {
            var err: Error?
            do {
                try self.set(object, forKey: key, expire: expire)
            } catch let error {
                err = error
            }
            completion?(err)
        }
    }
    
    public func set<T: Encodable>(_ object: T?, forKey key: String, expire: WQCacheExpiry = .never) throws {
        guard let obj = object else {
            try? self.delete(for: key)//为空的时候移除
            return
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(obj)
            try self.save(data, forKey: key)
        } catch let error {
            throw error
        }
    }
    
    public func object<T: Decodable>(forKey key: String) -> T? {
        if let data = self.read(for: key) {
            var obj: T?
            do {
                let decoder = JSONDecoder()
                obj = try decoder.decode(T.self, from: data)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
            return obj
        } else {
            return nil
        }
    }
    public func remove(_ key: String) throws {
       try self.delete(for: key)
    }
    deinit {
        pthread_rwlock_destroy(&lock)
    }
}

// MARK: - -- Disk
public extension WQCache {
    var totalSize: Int {
        if let attr = try? fileManager.attributesOfItem(atPath: baseDirectory.path),
            let size = attr[.size] as? Int {
            return size
        } else {
            return 0
        }
    }
}
// MARK: - --Accessory
public extension WQCache {
    convenience init(name: String, for directory: FileManager.SearchPathDirectory = .cachesDirectory) {
        let path = FileManager.url(for: directory).appendingPathComponent(name, isDirectory: true)
        self.init(path)
    }
    subscript<T: Codable>(key: String) -> T? {
        set {
            self.asyncSet(newValue, forKey: key)
        }
        get {
            return self.object(forKey: key)
        }
    }
    func path(for key: String, isDirectory: Bool = false) -> URL {
        return self.baseDirectory.appendingPathComponent(key, isDirectory: isDirectory)
    }
}
public extension WQCache {
    func save(_ data: Data,
              forKey key: String,
              options: Data.WritingOptions = .atomic,
              expire: WQCacheExpiry = .never) throws {
        let path = self.path(for: key)
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        do {
//            _ = fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
            try data.write(to: path, options: options)
            try? fileManager.setAttributes([.modificationDate: expire.expiryDate()], ofItemAtPath: path.path)
        } catch CocoaError.fileWriteOutOfSpace {
            let error = CocoaError.error(.fileWriteOutOfSpace, userInfo: nil, url: path)
            NotificationCenter.default.post(name: WQCache.didReceiveCacheMemoryWarning, object: nil, userInfo: ["error": error])
           throw error
        } catch let error {
            throw error
        }
    }
    func read(for key: String) -> Data?  {
        let path = self.path(for: key).path
        pthread_rwlock_rdlock(&lock)
        //FIXME: 需要解决老版本的修改日期问题
        if let attrs = try? fileManager.attributesOfItem(atPath: path),
            let date = attrs[.modificationDate] as? Date,
            date.timeIntervalSinceNow < 0 { //是否过期
            pthread_rwlock_unlock(&lock)
            try? self.delete(for: key)
            return nil
        } else {
            let data = fileManager.contents(atPath: path)
            pthread_rwlock_unlock(&lock)
            return data
        }
    }
    
   func delete(for key: String) throws {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        try fileManager.removeItem(at: path(for: key))
    }
    
    /// 清除数据
    ///
    /// - Parameters:
    ///   - isOnlyExpired: 是否只是清除过期的
    ///   - completion: 清除完成
    func clear(_ isOnlyExpired: Bool = false, completion: ((Error?) -> Void)? = nil) {
        ioQueue.async {
            pthread_rwlock_wrlock(&self.lock)
            var err: Error?
            if !isOnlyExpired {
                do {
                    try self.fileManager.contentsOfDirectory(at: self.baseDirectory,
                                                             includingPropertiesForKeys: nil,
                                                             options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles])
                        .forEach({ try self.fileManager.removeItem(at: $0) }) // 这里如果出错了就直接跑出异常 循环也不再继续
                } catch let error {
                    err = error
                }
            } else {
                let storageURL = URL(fileURLWithPath: self.baseDirectory.path)
                let resourceKeys: [URLResourceKey] = [
                    .isDirectoryKey,
                    .contentModificationDateKey,
                    .totalFileAllocatedSizeKey
                ]
                let fileEnumerator = self.fileManager.enumerator(
                    at: storageURL,
                    includingPropertiesForKeys: resourceKeys,
                    options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles],
                    errorHandler: nil
                )
                if let urlArray = fileEnumerator?.allObjects as? [URL] {
                    do {
                        try urlArray.forEach { url in
                            let resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
                            if resourceValues.isDirectory == false,
                                let date = resourceValues.contentModificationDate,
                                date.timeIntervalSinceNow < 0 {//过期了
                                try self.fileManager.removeItem(at: url)
                            }
                        }
                    } catch let error {
                        err = error
                    }
                } else {
                    err = CocoaError.error(CocoaError.fileEnumeratorFailed, userInfo: nil, url: nil)
                }
            }
            pthread_rwlock_unlock(&self.lock)
            completion?(err)
        }
    }
}

public extension CocoaError {
    static let fileWriteInvalidValue = CocoaError.Code(rawValue: -20_000)
    static let fileEnumeratorFailed = CocoaError.Code(rawValue: -20_100)
}

public enum WQCacheExpiry { //过期时间可以每个Cache单独维护一个字典
    case never
    case seconds(Double)
    case date(Date)
}
extension WQCacheExpiry {
    /// 4001/1/1 8:0:0 (北京时间)
    static let distantFuture: Double = 64_092_211_200.0
    
    func expiryTime() -> Double {
        switch self {
        case .never:
            return WQCacheExpiry.distantFuture
        case let .seconds(secs):
            return CFAbsoluteTimeGetCurrent() + secs
        case let .date(time):
            return time.timeIntervalSince1970
        }
    }
    func expiryDate() -> Date {
        switch self {
        case .never:
            return Date.distantFuture
        case let .seconds(secs):
            return Date() + secs
        case let .date(time):
            return time
        }
    }
    func isExpiry(at date: Date) -> Bool {
        switch self {
        case .never:
            return false
        case let .seconds(secs):
            return date + secs < Date()
        case let .date(time):
            return date > time
        }
    }
}
