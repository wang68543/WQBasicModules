//
//  WQCache.swift
//  WQBasicModules
//
//  Created by WangQiang on 2018/9/19.
//

import UIKit
public final class WQCache {
    public static let `default` = WQCache(name: "wq.defaultCache.disk.com", for: .cachesDirectory)
    
    public let urlPath: URL
    
    init(_ url: URL) {
        urlPath = url
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try  FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                debugPrint("创建文件夹失败", error.localizedDescription)
            }
        }
    }
    
    @discardableResult
    func set<T: Encodable>(_ object: T?, for key: String) -> Bool {
        guard let obj = object else {
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
    func object<T: Decodable>(_ key: String) -> T? {
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
    func remove(_ key: String) {
        self.delete(for: key)
    }

}
extension WQCache {
    convenience init(name: String, for directory: FileManager.SearchPathDirectory = .cachesDirectory) {
        let path = FileManager.url(for: directory).appendingPathComponent(name)
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
extension WQCache {
    private func save(_ data: Data, for key: String) {
        do {
            try data.write(to: path(for: key))
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    private func load(for key: String) -> Data? {
        do {
           return try Data(contentsOf: path(for: key))
        } catch {
            return nil
        } 
    }
    private func delete(for key: String) {
        do {
            try FileManager.default.removeItem(at: path(for: key))
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
