//
//  WQFileManager+Path.swift
//  Pods
//
//  Created by hejinyin on 2018/1/26.
//

import Foundation

public extension FileManager {
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
}
