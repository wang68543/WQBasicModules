//
//  WQString+ExtraCode.swift
//  FBSnapshotTestCase
//
//  Created by hejinyin on 2018/1/31.
//

import Foundation
public extension String {
    /// md5加密 默认小写
    public func md5(lower: Bool = true) -> String {
        let str = self as NSString
        var md5Str: String
        if lower {
            md5Str = str.md5Lowercase()
        } else {
            md5Str = str.md5()
        }
        return md5Str
    }
    
   public func oc_sha1() -> String {
        let str = self as NSString 
        return str.sha1()
    }
}
