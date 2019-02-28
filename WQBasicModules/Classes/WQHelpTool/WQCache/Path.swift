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
extension Path {
    /**
     Returns the parent directory for this path.
     
     Path is not aware of the nature of the underlying file, but this is
     irrlevant since the operation is the same irrespective of this fact.
     
     - Note: always returns a valid path, `Path.root.parent` *is* `Path.root`.
     */
    public var parent: Path {
        let index = string.lastIndex(of: "/")!
        let substr = string[string.indices.startIndex..<index]
        return Path(string: String(substr))
    }
    /// Returns a `Path` containing `FileManager.default.currentDirectoryPath`.
    public static var cwd: Path {
        return Path(string: FileManager.default.currentDirectoryPath)
    }
    /// Returns a `Path` representing the user’s home directory
    public static var home: Path {
        let string: String
        #if os(macOS)
        if #available(OSX 10.12, *) {
            string = FileManager.default.homeDirectoryForCurrentUser.path
        } else {
            string = NSHomeDirectory()
        }
        #else
        string = NSHomeDirectory()
        #endif
        return Path(string: string)
    }
    /// Helper to allow search path and domain mask to be passed in.
    private static func path(for searchPath: FileManager.SearchPathDirectory) -> Path {
        #if os(Linux)
        // the urls(for:in:) function is not implemented on Linux
        //TODO strictly we should first try to use the provided binary tool
        
        let foo = { ProcessInfo.processInfo.environment[$0].flatMap(Path.init) ?? $1 }
        
        switch searchPath {
        case .documentDirectory:
            return Path.home/"Documents"
        case .applicationSupportDirectory:
            return foo("XDG_DATA_HOME", Path.home/".local/share")
        case .cachesDirectory:
            return foo("XDG_CACHE_HOME", Path.home/".cache")
        default:
            fatalError()
        }
        #else
        guard let pathString = FileManager.default.urls(for: searchPath, in: .userDomainMask).first?.path else { return defaultUrl(for: searchPath) }
        return Path(string: pathString)
        #endif
    }
    
    /**
     The root for user documents.
     - Note: There is no standard location for documents on Linux, thus we return `~/Documents`.
     - Note: You should create a subdirectory before creating any files.
     */
    public static var documents: Path {
        return path(for: .documentDirectory)
    }
    
    /**
     The root for cache files.
     - Note: On Linux this is `XDG_CACHE_HOME`.
     - Note: You should create a subdirectory before creating any files.
     */
    public static var caches: Path {
        return path(for: .cachesDirectory)
    }
}
extension Path {
    /**
     Returns a string representing the relative path to `base`.
     
     - Note: If `base` is not a logical prefix for `self` your result will be prefixed some number of `../` components.
     - Parameter base: The base to which we calculate the relative path.
     - ToDo: Another variant that returns `nil` if result would start with `..`
     */
    public func relative(to base: Path) -> String {
        // Split the two paths into their components.
        // FIXME: The is needs to be optimized to avoid unncessary copying.
        let pathComps = (string as NSString).pathComponents
        let baseComps = (base.string as NSString).pathComponents
        
        // It's common for the base to be an ancestor, so try that first.
        if pathComps.starts(with: baseComps) {
            // Special case, which is a plain path without `..` components.  It
            // might be an empty path (when self and the base are equal).
            let relComps = pathComps.dropFirst(baseComps.count)
            return relComps.joined(separator: "/")
        } else {
            // General case, in which we might well need `..` components to go
            // "up" before we can go "down" the directory tree.
            var newPathComps = ArraySlice(pathComps)
            var newBaseComps = ArraySlice(baseComps)
            while newPathComps.prefix(1) == newBaseComps.prefix(1) {
                // First component matches, so drop it.
                newPathComps = newPathComps.dropFirst()
                newBaseComps = newBaseComps.dropFirst()
            }
            // Now construct a path consisting of as many `..`s as are in the
            // `newBaseComps` followed by what remains in `newPathComps`.
            var relComps = Array(repeating: "..", count: newBaseComps.count)
            relComps.append(contentsOf: newPathComps)
            return relComps.joined(separator: "/")
        }
    }
    /**
     Joins a path and a string to produce a new path.
     
     Path.root.join("a")             // => /a
     Path.root.join("a/b")           // => /a/b
     Path.root.join("a").join("b")   // => /a/b
     Path.root.join("a").join("/b")  // => /a/b
     
     - Note: `..` and `.` components are interpreted.
     - Note: pathComponent *may* be multiple components.
     - Note: symlinks are *not* resolved.
     - Parameter pathComponent: The string to join with this path.
     - Returns: A new joined path.
     - SeeAlso: `Path./(_:_:)`
     */
    public func join<S>(_ addendum: S) -> Path where S: StringProtocol {
        return Path(string: join_(prefix: string, appending: addendum))
    }
    
    /**
     Joins a path and a string to produce a new path.
     
     Path.root/"a"       // => /a
     Path.root/"a/b"     // => /a/b
     Path.root/"a"/"b"   // => /a/b
     Path.root/"a"/"/b"  // => /a/b
     
     - Note: `..` and `.` components are interpreted.
     - Note: pathComponent *may* be multiple components.
     - Note: symlinks are *not* resolved.
     - Parameter lhs: The base path to join with `rhs`.
     - Parameter rhs: The string to join with this `lhs`.
     - Returns: A new joined path.
     - SeeAlso: `join(_:)`
     */
    @inlinable
    public static func /<S>(lhs: Path, rhs: S) -> Path where S: StringProtocol {
        return lhs.join(rhs)
    }
    
    @inline(__always)
    private func join_<S>(prefix: String, appending: S) -> String where S: StringProtocol {
        return join_(prefix: prefix, pathComponents: appending.split(separator: "/"))
    }
    
    private func join_<S>(prefix: String, pathComponents: S) -> String where S: Sequence, S.Element: StringProtocol {
        assert(prefix.first == "/")
        
        var rv = prefix
        for component in pathComponents {
            
            assert(!component.contains("/"))
            
            switch component {
            case "..":
                let start = rv.indices.startIndex
                let index = rv.lastIndex(of: "/")!
                if start == index {
                    rv = "/"
                } else {
                    rv = String(rv[start..<index])
                }
            case ".":
                break
            default:
                if rv == "/" {
                    rv = "/\(component)"
                } else {
                    rv = "\(rv)/\(component)"
                }
            }
        }
        return rv
    }

}
#if !os(Linux)
func defaultUrl(for searchPath: FileManager.SearchPathDirectory) -> Path {
    switch searchPath {
    case .documentDirectory:
        return Path.home/"Documents"
    case .applicationSupportDirectory:
        return Path.home/"Library/Application Support"
    case .cachesDirectory:
        return Path.home/"Library/Caches"
    default:
        fatalError()
    }
}
#endif
//MARK: Filesystem Attributes
public extension Path {
    /**
     Returns the creation-time of the file.
     - Note: Returns `nil` if there is no creation-time, this should only happen if the file doesn’t exist.
     - Important: On Linux this is filesystem dependendent and may not exist.
     */
    public var ctime: Date? {
        do {
            let attrs = try FileManager.default.attributesOfItem(atPath: string)
            return attrs[.creationDate] as? Date
        } catch {
            return nil
        }
    }
    
    /**
     Returns the modification-time of the file.
     - Note: If this returns `nil` and the file exists, something is very wrong.
     */
    public var mtime: Date? {
        do {
            let attrs = try FileManager.default.attributesOfItem(atPath: string)
            return attrs[.modificationDate] as? Date
        } catch {
            return nil
        }
    }
}
/**
 Provided for relative-path coding. See the instructions in our
 [README](https://github.com/mxcl/Path.swift/#codable).
 */
public extension CodingUserInfoKey {
    /**
     If set on an `Encoder`’s `userInfo` all paths are encoded relative to this path.
     
     For example:
     
     let encoder = JSONEncoder()
     encoder.userInfo[.relativePath] = Path.home
     encoder.encode([Path.home, Path.home/"foo"])
     
     - Remark: See the [README](https://github.com/mxcl/Path.swift/#codable) for more information.
     */
    static let relativePath = CodingUserInfoKey(rawValue: "dev.mxcl.Path.relative")!
}

/**
 Provided for relative-path coding. See the instructions in our
 [README](https://github.com/mxcl/Path.swift/#codable).
 */
extension Path: Codable {
    /// - SeeAlso: `CodingUserInfoKey.relativePath`
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(String.self)
        if value.hasPrefix("/") {
            string = value
        } else {
            guard let root = decoder.userInfo[.relativePath] as? Path else {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Path cannot decode a relative path if `userInfo[.relativePath]` not set to a Path object."))
            }
            string = (root/value).string
        }
    }
    
    /// - SeeAlso: `CodingUserInfoKey.relativePath`
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let root = encoder.userInfo[.relativePath] as? Path {
            try container.encode(relative(to: root))
        } else {
            try container.encode(string)
        }
    }
}
extension Path: CustomStringConvertible {
    /// Returns `Path.string`
    public var description: String {
        return string
    }
}

extension Path: CustomDebugStringConvertible {
    /// Returns eg. `Path(string: "/foo")`
    public var debugDescription: String {
        return "Path(\(string))"
    }
}
