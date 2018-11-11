//
//  Data+Utilies.swift
//  Alamofire
//
//  Created by WangQiang on 2018/10/27.
//

import Foundation

public extension Data {
    var md5: String {
        return  (self as NSData).md5()
    }
}
