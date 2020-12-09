//
//  String+Localized.swift
//  CarWePlay
//
//  Created by iMacHuaSheng on 2019/10/11.
//  Copyright © 2019 iMacHuaSheng. All rights reserved.
//

import Foundation
extension String {
    
     var localized: String {
        return self.localized()
     }
    func localized(_ tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
    
}
