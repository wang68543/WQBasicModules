//
//  WQCache.swift
//  WQBasicModules
//
//  Created by WangQiang on 2018/9/19.
//

import UIKit

public final class WQCache {
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
//        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCacheMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    public func fileExists(_ key: String) -> Bool {
        return fileManager.fileExists(atPath: self.path(for: key).path)
    }
    
    /// 异步存储数据
    ///
    /// - Parameters:
    ///   - completion: 存储完成回调
    public func asyncSet<T: Encodable>(_ object: T?,
                                       for key: String,
                                       completion: ((Error?) -> Void)? = nil) {
        ioQueue.async {
            var error: Error?
            defer {
                if let complete = completion {
                    DispatchQueue.main.async {
                      complete(error)
                    } 
                }
            }
            guard let obj = object else {
                try? self.delete(for: key)//为空的时候移除
                error = CocoaError.error(CocoaError.fileWriteInvalidValue, userInfo: nil, url: self.path(for: key))
                return
            }
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(obj)
                try self.save(data, for: key)
            } catch let err {
                error = err
            } 
        }
    }
    
    public func set<T: Encodable>(_ object: T?, for key: String) throws {
        guard let obj = object else {
            try? self.delete(for: key)//为空的时候移除
            return
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(obj)
            try self.save(data, for: key)
        } catch let error {
            throw error
        }
    }
    
    public func object<T: Decodable>(_ key: String, expire: WQCacheExpiry = .never) -> T? {
        if let data = self.read(for: key, expire: expire) {
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
    @objc func didReceiveCacheMemoryWarning(_ note: Notification) {
        
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
    
    func clear() throws {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        try fileManager.contentsOfDirectory(at: self.baseDirectory,
                                            includingPropertiesForKeys: nil,
                                            options: .skipsSubdirectoryDescendants)
            .forEach({ try fileManager.removeItem(at: $0) }) // 这里如果出错了就直接跑出异常 循环也不再继续
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
            self.asyncSet(newValue, for: key)
        }
        get {
            return self.object(key)
        }
    }
    func path(for key: String, isDirectory: Bool = false) -> URL {
        return self.baseDirectory.appendingPathComponent(key, isDirectory: isDirectory)
    }
}
public extension WQCache {
    func save(_ data: Data, for key: String) throws {
        let cachePath = path(for: key)
        try? save(data, for: cachePath, options: .atomic)
    }
    
    func save(_ data: Data, for path: URL, options: Data.WritingOptions) throws {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        do {
//            _ = fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
            try data.write(to: path, options: options)
//             try fileManager.setAttributes([.modificationDate: Date()], ofItemAtPath: path)
        } catch CocoaError.fileWriteOutOfSpace {
            let error = CocoaError.error(.fileWriteOutOfSpace, userInfo: nil, url: path)
            NotificationCenter.default.post(name: WQCache.didReceiveCacheMemoryWarning, object: nil, userInfo: ["error": error])
           throw error
        } catch let error {
            throw error
        }
    }
    func read(for key: String, expire: WQCacheExpiry) -> Data? {
        let path = self.path(for: key).path
        pthread_rwlock_rdlock(&lock)
        switch expire {
        case .never: break
        default:
            do {
                let attrs = try fileManager.attributesOfItem(atPath: path)
                var isExpiry: Bool = false
                if let modifydate = attrs[.modificationDate] as? Date {
                    isExpiry = expire.isExpiry(at: modifydate)
                } else if let createDate = attrs[.creationDate] as? Date {
                    isExpiry = expire.isExpiry(at: createDate)
                }
                if isExpiry {
                    pthread_rwlock_unlock(&lock)
                    try? self.delete(for: key)
                }
            } catch CocoaError.fileReadNoSuchFile {
                pthread_rwlock_unlock(&lock)
                return nil
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
        let data = fileManager.contents(atPath: path)
        pthread_rwlock_unlock(&lock)
        return data
    }
    
   func delete(for key: String) throws {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }
        try fileManager.removeItem(at: path(for: key))
    }
}

public extension CocoaError {
    static let fileWriteInvalidValue = CocoaError.Code(rawValue: -20_000)
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
