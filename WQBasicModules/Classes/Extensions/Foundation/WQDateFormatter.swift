//
//  WQDateFormatter.swift
//  WQBasicModules
//
//  Created by hejinyin on 2018/1/21.
//

import UIKit

public class WQDateFormatter: DateFormatter {
    public static let shared: WQDateFormatter = {
        let formatter = WQDateFormatter() 
        return formatter
    }()
}
