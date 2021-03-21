//
//  BluetoothManager.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2021/3/19.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import CoreBluetooth
open class BluetoothManager: NSObject {
    lazy var centralMgr: CBCentralManager = {
        let mgr = CBCentralManager(delegate: nil, queue: nil)
        return mgr
    }()
}
