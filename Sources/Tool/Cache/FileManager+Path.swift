//
//  FileManager+Path.swift
//  Pods
//
//  Created by hejinyin on 2018/1/26.
//

import Foundation

public extension FileManager {

    // Document:会备份这个文件夹
    // Library苹果建议用来存放默认设置或其它状态信息。会被iTunes同步 但是要除了Caches子目录外
    // Library/Preferences:包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
    // Library/Caches:存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除;磁盘空间不够时 系统会删 
    // temp:存放临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除
         static let urlDocument = url(for: .documentDirectory)
          static let urlLibrary = url(for: .libraryDirectory)
           static let urlCaches = url(for: .cachesDirectory)

        static let pathDocument = path(for: .documentDirectory)
         static let pathLibrary = path(for: .libraryDirectory)
          static let pathCaches = path(for: .cachesDirectory)

     static func url(for directory: FileManager.SearchPathDirectory = .cachesDirectory) -> URL {
        return self.default.urls(for: directory, in: .userDomainMask).last!
    }
    static func path(for directory: FileManager.SearchPathDirectory = .cachesDirectory) -> String {
       return  NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).last!
    }

    // 监听目录结构更改
    func addlisten() {
        let folder = try? FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false)
        print(folder!.path)
        let fd = open(folder!.path, O_CREAT, 0o644)
        let queue = DispatchQueue(label: "m")
        let source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fd,
                                                               eventMask: .all,
                                                               queue: queue)
        source.setEventHandler {
            print("folder changed")
        }
        source.resume()

//        let result = FileManager.default.createFile(atPath: folder!.path + "/abc", contents: nil, attributes: nil)
//        if result {
//            print(0)
//        }
//        else {
//            print(1)
//        }
    }

}
