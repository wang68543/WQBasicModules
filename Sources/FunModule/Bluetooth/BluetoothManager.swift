//
//  BluetoothManager.swift
//  WQBasicModules
//
//  Created by iMacHuaSheng on 2021/3/19.
//  Copyright © 2021 CocoaPods. All rights reserved.
//
//  官方蓝牙文档
//  https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html#//apple_ref/doc/uid/TP40013257-CH1-SW1
import Foundation
import CoreBluetooth
open class BluetoothManager: NSObject {
    public lazy var centralMgr: CBCentralManager = {
        let mgr = CBCentralManager(delegate: nil, queue: nil)
        return mgr
    }()
     
    open var connectedPeripherals: [CBPeripheral] = []
    
    /// 等待自动连接的设备 (这个设备必定是之前自动连接过的)
    internal var waitToConnectPeripheral: String?
    /// 等待
    internal var waitBLePoweredOnToScan: Bool = false
    
}
public extension BluetoothManager {
    /// 设备的连接状态改变
    static let peripheralStateDidChange = Notification.Name(rawValue: "peripheralStateDidChangeNotification")
    /// 接收到设备的广播通知
    static let didReceivedAdvertisement = Notification.Name(rawValue: "didReceivedAdvertisementNotification")
}
