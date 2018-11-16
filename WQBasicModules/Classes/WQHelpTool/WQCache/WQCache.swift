//
//  WQCache.swift
//  WQBasicModules
//
//  Created by WangQiang on 2018/9/19.
//

import UIKit
public final class WQCache {
    
    //  "wq.defaultCache.disk.com"
    public static let `default` = WQCache(name: "defaultCache", for: .cachesDirectory)
    public let urlPath: URL
    public let fileManager: FileManager
    
    /// 根据路径创建存储实例
    ///
    /// - Parameters:
    ///   - url: 存储文件夹(需是app路径下面的二级目录)
    ///   - fileManager: 文件管理器
    init(_ url: URL, fileManager: FileManager = FileManager.default) {
        var path = url
        path.deleteLastPathComponent()
        path = path.appendingPathComponent("wq.disk.cache.com", isDirectory: true)
            .appendingPathComponent(url.lastPathComponent)
        urlPath = path
        self.fileManager = fileManager
        if !fileManager.fileExists(atPath: path.path) {
            do {
                try  fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                debugPrint("创建文件夹失败", error.localizedDescription)
            }
        }
    }
    
    @discardableResult
    public func set<T: Encodable>(_ object: T?, for key: String) -> Bool {
        guard let obj = object else {
            self.delete(for: key)//为空的时候移除
            return false
        }
        var isSuccess: Bool = true
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(obj)
            self.save(data, for: key)
        } catch let error {
            isSuccess = false
            debugPrint(error.localizedDescription)
        }
       return isSuccess
    }
    public func object<T: Decodable>(_ key: String) -> T? {
        if let data = self.load(for: key) {
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
    public func remove(_ key: String) {
        self.delete(for: key)
    }

}

// MARK: - -- Disk
public extension WQCache {
    var totalSize: Int {
        var size: Int = 0
        do {
           let attr = try fileManager.attributesOfItem(atPath: urlPath.path)
            size = (attr[.size] as? Int) ?? 0
        } catch let error {
            debugPrint(error.localizedDescription)
//            return 0
        }
        return size
    }
    
    func clear() -> Error? {
        do {
             try fileManager
                .contentsOfDirectory(at: self.urlPath,
                                     includingPropertiesForKeys: nil,
                                     options: .skipsSubdirectoryDescendants)
        } catch let error {
            debugPrint(error.localizedDescription)
            return error
        }
       return nil
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
            self.set(newValue, for: key)
        }
        get {
            return self.object(key)
        }
    }
    func path(for key: String) -> URL {
        return self.urlPath.appendingPathComponent(key)
    }
}
public extension WQCache {
    @discardableResult
    func save(_ data: Data, for key: String) -> Error? {
        do {
            try data.write(to: path(for: key), options: .atomic)
        } catch let error {
            debugPrint(error.localizedDescription)
            return error
        }
        return nil
    }
    func load(for key: String) -> Data? {
        do {
           return try Data(contentsOf: path(for: key))
        } catch {
            return nil
        } 
    }
   @discardableResult
   func delete(for key: String) -> Error? {
        do {
            try fileManager.removeItem(at: path(for: key))
        } catch let error {
            debugPrint(error.localizedDescription)
            return error
        }
        return nil
    }
}
