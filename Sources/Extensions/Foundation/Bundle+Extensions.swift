//
//  Bundle+Extensions.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/1/26.
//

import Foundation
public extension Bundle {
    func image(for named: String, ofType type: String? = nil) -> UIImage? {
        guard let path = self.path(forResource: named, ofType: type) else {
            return nil
        }
        return UIImage(contentsOfFile: path)
    }

