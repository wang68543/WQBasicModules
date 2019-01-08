//
//  WQString+Extensions.swift
//  Pods
//
//  Created by WangQiang on 2019/1/8.
//

import Foundation
public extension String {
    
    /// 序列化URL的查询参数 (可处理包含=)
    ///
    /// - Returns: 键值对
    func serializedURLQueryParameters() -> [String: String] {
        var parameters: [String: String] = [:]
        let string = self.components(separatedBy: "?").last
        guard let queryString = string,
            !queryString.isEmpty else {
            return parameters
        }
        let compments = queryString.components(separatedBy: "&")
        compments.forEach { compment in
            if let range = compment.range(of: "=") {
                let keyRange = Range(uncheckedBounds: (lower: compment.startIndex, upper: range.lowerBound))
                let valueRange = Range(uncheckedBounds: (lower: range.upperBound, upper: compment.endIndex))
                if !keyRange.isEmpty && !valueRange.isEmpty {
                    let key = String(compment[keyRange])
                    let value = String(compment[valueRange])
                    parameters[key] = value
                }
            }
        }
        return parameters
    }
}
