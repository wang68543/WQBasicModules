//
//  String+Localized.swift
//  CarWePlay
//
//  Created by iMacHuaSheng on 2019/10/11.
//  Copyright © 2019 iMacHuaSheng. All rights reserved.
//

import Foundation
public extension String { 
    var localized: String {
        return self.localized()
     }
    
    func localized(using tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
    
    func localized(format arguments: CVarArg..., using tableName: String?, in bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        let localizedString = localized(using: tableName, bundle: bundle, value: value, comment: comment)
        return String(format: localizedString, arguments: arguments)
    }
    
}
