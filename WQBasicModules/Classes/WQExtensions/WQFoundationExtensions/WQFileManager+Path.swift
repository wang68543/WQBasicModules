//
//  WQFileManager+Path.swift
//  Pods
//
//  Created by hejinyin on 2018/1/26.
//

import Foundation
extension FileManager{
    public static let urlDocument   = url(for: .documentDirectory)
    public static let urlLibrary    = url(for: .libraryDirectory)
    public static let urlCaches     = url(for: .cachesDirectory) 
    
    public static let pathDocument  = path(for: .documentDirectory)
    public static let pathLibrary   = path(for: .libraryDirectory)
    public static let pathCaches    = path(for: .cachesDirectory)
    
    
    public static func url(for directory: FileManager.SearchPathDirectory = .cachesDirectory) -> URL {
        return self.default.urls(for: directory, in: .userDomainMask).last!
    }
    public static func path(for directory: FileManager.SearchPathDirectory = .cachesDirectory) -> String {
       return  NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).last!
    }
}

