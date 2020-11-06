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
   
    var freeDiskSpaceInBytes: Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
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
/**
 #pragma 获取总内存大小
 + (NSString *)getTotalMemorySize {
     long long totalMemorySize = [NSProcessInfo processInfo].physicalMemory;
     return [self fileSizeToString:totalMemorySize];
 }

 #pragma 获取当前可用内存
 + (NSString *)getAvailableMemorySize {
     vm_statistics_data_t vmStats;
     mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
     kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
     if (kernReturn != KERN_SUCCESS) {
         return @"内存查找失败";
     }
     long long availableMemorySize = ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
     return [self fileSizeToString:availableMemorySize];
 }

 #pragma 获取总磁盘容量
 + (NSString *)getTotalDiskSize {
     struct statfs buf;
     unsigned long long totalDiskSize = -1;
     if (statfs("/var", &buf) >= 0) {
         totalDiskSize = (unsigned long long)(buf.f_bsize * buf.f_blocks);
     }
     return [self fileSizeToString:totalDiskSize];
 }

 #pragma 获取可用磁盘容量  f_bavail 已经减去了系统所占用的大小，比 f_bfree 更准确
 + (NSString *)getAvailableDiskSize {
     struct statfs buf;
     unsigned long long availableDiskSize = -1;
     if (statfs("/var", &buf) >= 0) {
         availableDiskSize = (unsigned long long)(buf.f_bsize * buf.f_bavail);
     }
     return [self fileSizeToString:availableDiskSize];
 }

 + (NSString *)fileSizeToString:(unsigned long long)fileSize {
     NSInteger KB = 1024;
     NSInteger MB = KB*KB;
     NSInteger GB = MB*KB;

     if (fileSize < 10)  {
         return @"0 B";
     }else if (fileSize < KB) {
         return @"< 1 KB";
     }else if (fileSize < MB) {
         return [NSString stringWithFormat:@"%.2f KB",((CGFloat)fileSize)/KB];
     }else if (fileSize < GB) {
         return [NSString stringWithFormat:@"%.2f MB",((CGFloat)fileSize)/MB];
     }else {
          return [NSString stringWithFormat:@"%.2f GB",((CGFloat)fileSize)/GB];
     }
 }

 作者：Gavin_Kang
 链接：https://juejin.im/post/6844904184588795911
 来源：掘金
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
