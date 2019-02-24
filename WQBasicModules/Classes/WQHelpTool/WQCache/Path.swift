//
//  Path.swift
//  WQBasicModules
//
//  Created by WangQiang on 2019/2/16.
//  借鉴此处 https://github.com/mxcl/Path.swift.git 

import Foundation
public struct Path {
    public init(string: String) {
        assert(string.first == "/")
        assert(string.last != "/" || string == "/")
        assert(string.split(separator: "/").contains("..") == false)
        self.string = string
    }
    public init?(url: URL) {
        guard url.scheme == "file" else { return nil }
        self.string = url.path
        //NOTE: URL cannot be a file-reference url, unlike NSURL, so this always works
    }
    /// The underlying filesystem path
    public let string: String
    
    /// Returns a `URL` representing this file path.
    public var url: URL {
        return URL(fileURLWithPath: string)
    }
}
public extension Path {
    /// Returns true if the path represents an actual filesystem entry.
    var exists: Bool {
        return FileManager.default.fileExists(atPath: string)
    }
    
    /// Returns true if the path represents an actual filesystem entry that is *not* a directory.
    var isFile: Bool {
        var isDir: ObjCBool = true
        return FileManager.default.fileExists(atPath: string, isDirectory: &isDir) && !isDir.boolValue
    }
    
    /// Returns true if the path represents an actual directory.
    var isDirectory: Bool {
        var isDir: ObjCBool = false
        return FileManager.default.fileExists(atPath: string, isDirectory: &isDir) && isDir.boolValue
    }
    
    /// Returns true if the path represents an actual file that is also readable by the current user.
    var isReadable: Bool {
        return FileManager.default.isReadableFile(atPath: string)
    }
    
    /// Returns true if the path represents an actual file that is also writable by the current user.
    var isWritable: Bool {
        return FileManager.default.isWritableFile(atPath: string)
    }
    
    /// Returns true if the path represents an actual file that is also deletable by the current user.
    var isDeletable: Bool {
        // FileManager.isDeletableFile returns true if there is *not* a file there
        return exists && FileManager.default.isDeletableFile(atPath: string) 
    }
    
    /// Returns true if the path represents an actual file that is also executable by the current user.
    var isExecutable: Bool {
        if access(string, X_OK) == 0 {
            // FileManager.isExxecutableFile returns true even if there is *not*
            // a file there *but* if there was it could be *made* executable
            return FileManager.default.isExecutableFile(atPath: string)
        } else {
            return false
        }
    }
    
    /// Returns `true` if the file is a symbolic-link (symlink).
    var isSymlink: Bool {
        var sbuf = stat()
        lstat(string, &sbuf)
        return (sbuf.st_mode & S_IFMT) == S_IFLNK
    }
}
