//
//  BluetoothManager+Peripheral.swift
//  Pods
//
//  Created by iMacHuaSheng on 2021/3/19.
//

import Foundation
import CoreBluetooth
// scan
public extension BluetoothManager {
    
    
    /// 重连设备
    /// - Parameters:
    ///   - peripheral: 设备的唯一标识
    ///   - services: 设备的服务标识
    func retrievePeripheral(_ peripheral: UUID, services: [CBUUID]) {
        var device: CBPeripheral? = ni
        let peripherals = centralMgr.retrievePeripherals(withIdentifiers: [peripheral])
        if !peripherals.isEmpty,
           let dev = peripherals.first(where: {$0.identifier == peripheral }) {
            device = dev
        } else {
            // 看看其他的App是否连接了这个设备
            let devices = centralMgr.retrieveConnectedPeripherals(withServices: services)
            if !devices.isEmpty,
               let dev = devices.first(where: {$0.identifier == peripheral }) {
                device = dev
            }
        }
        if let dev = device {
            centralMgr.connect(dev, options: nil)
        } else {
            //扫描
        }
    }
}
// connect
public extension BluetoothManager {
    
}
