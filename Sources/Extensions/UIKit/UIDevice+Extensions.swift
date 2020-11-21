//
//  UIDevice+Extensions.swift
//  HandMetroSwift
//
//  Created by WQ on 2019/6/11.
//

import Foundation

public extension UIDevice {
    // iPhone 6sPlus -> iPhone8,2
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine) 
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8,
                value != 0 else {
                    return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        } 
    }
    
    /// 判断是否是模拟器
    static let isEmulator: Bool = {
        #if arch(i386) || arch(x86_64)
        return true
        #else
        return false
        #endif
    }()
}


// https://juejin.im/post/6844904184588795911
public extension UIDevice {
    /// 内存 大小 按照 1024来计算
    static let physicalMemory = Int64(ProcessInfo.processInfo.physicalMemory)
    /// 当前内存可用大小
    var freeMemory: Int64 {
        //https://juejin.cn/post/6844904184588795911
        let host = mach_host_self()
        var size = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size/MemoryLayout<integer_t>.size)
        var pagesize = vm_size_t()
        var vmstat = vm_statistics_data_t()
         host_page_size(host, &pagesize);
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &vmstat) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                host_statistics(host, host_flavor_t(HOST_VM_INFO), host_info_t($0), &size);
            }
        }
        if kerr == KERN_SUCCESS {
            return Int64((vmstat.free_count + vmstat.inactive_count) *  UInt32(pagesize))
        }
        return .zero
    }
    /// 磁盘 总空间 按照 1000来计算
    static let diskStorage: Int64 = {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return .zero
        }
        do {
            if #available(iOS 11.0, *) {
                let results = try url.resourceValues(forKeys: [.volumeTotalCapacityKey])
                return Int64(results.volumeTotalCapacity ?? .zero)
            } else {
                let results = try FileManager.default.attributesOfFileSystem(forPath: url.path)
                return Int64((results[.systemSize] as? Int) ?? .zero)
            }
        } catch let error {
            debugPrint(error)
        }
        return .zero
         
    }()
    /// 磁盘可用空间 按照 1000来计算
    var freeDiskStorage: Int64 {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return .zero
        }
        do {
            if #available(iOS 11.0, *) {
            let results = try url.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
                return results.volumeAvailableCapacityForImportantUsage ?? .zero
            } else {
                let results = try FileManager.default.attributesOfFileSystem(forPath: url.path)
                return Int64((results[.systemFreeSize] as? Int) ?? .zero)
            }
        } catch let error {
            debugPrint(error)
            return .zero
        }
    }
}

public extension UIDevice {
    /// 内存 大小 按照 1024来计算
    static let formatMemory: String = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.zeroPadsFractionDigits = true
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: UIDevice.physicalMemory)
    }()
    /// 当前内存可用大小
    var formatFreeMemory: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.zeroPadsFractionDigits = true
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: UIDevice.current.freeMemory)
    }
    /// 磁盘 总空间 按照 1000来计算
    static let formatDiskStorage: String = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.zeroPadsFractionDigits = true
        formatter.countStyle = .file
        return formatter.string(fromByteCount: UIDevice.diskStorage)
    }()
    /// 磁盘可用空间 按照 1000来计算
    var formatDiskFreeStorage: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.zeroPadsFractionDigits = true
        formatter.countStyle = .file
        return formatter.string(fromByteCount: UIDevice.current.freeDiskStorage)
    }
}
