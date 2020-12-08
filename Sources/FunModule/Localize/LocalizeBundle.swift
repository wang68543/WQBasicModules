//
//  LocalizeBundle.swift
//  Pods
//
//  Created by 王强 on 2020/12/9.
//

import UIKit

open class LocalizeBundle: Bundle {

    open override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = Localize.currentBundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
       return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
