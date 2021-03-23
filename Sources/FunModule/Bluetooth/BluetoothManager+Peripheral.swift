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
    
    
    func connect(_ peripheral: CBPeripheral, options: [String: Any]? = nil) {
        // TODO: 系统默认没有连接超时 如果自定义实现连接超时 需要手动调用cancelPeripheralConnection
        switch peripheral.state {
        case .connected, .connecting:
            self.peripheral(peripheral, stateDidChange: peripheral.state)
            //TODO: 需设置代理
        default:
            guard self.centralMgr.state == .poweredOff else {
                self.peripheral(peripheral, stateDidChange: .disconnected)
                //连接失败
                return
            }
            objc_sync_enter(self)
            self.centralMgr.connect(peripheral, options: options)
            connectedPeripherals.append(peripheral)
            objc_sync_exit(self)
        }
    }
    
    /// 重连设备
    /// - Parameters:
    ///   - peripheral: 设备的唯一标识
    ///   - services: 设备的服务标识
    func retrievePeripheral(_ peripheral: UUID, services: [CBUUID]) {
        var device: CBPeripheral?
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
            self.connect(dev, options: nil)
        } else {
            //扫描
            scan(nil, options: nil, peripheral: peripheral)
        }
    }
    
    /// 扫描设备
    /// - Parameters:
    ///   - services: 设备的服务
    ///   - options: 扫描设备的参数
    ///   - peripheral: 自动连接的设备名称
    func scan(_ services: [CBUUID]?, options: [String: Any]?, peripheral: UUID? = nil) {
        objc_sync_enter(self)
        self.waitToConnectPeripheral = peripheral?.uuidString
        if centralMgr.state != .poweredOn {
            self.waitBLePoweredOnToScan = true
        } else {
            self.waitBLePoweredOnToScan = false
            if !centralMgr.isScanning {
                centralMgr.scanForPeripherals(withServices: services, options: options)
            }
        }
        objc_sync_exit(self)
    }
    // 设备连接的状态改变了
    func peripheral(_ peripheral: CBPeripheral, stateDidChange state: CBPeripheralState) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: BluetoothManager.peripheralStateDidChange, object: peripheral, userInfo: nil)
        }
    }
    
}
extension BluetoothManager: CBCentralManagerDelegate {
 
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            let identifier = UUID(uuidString: self.waitToConnectPeripheral ?? "")
            if self.waitBLePoweredOnToScan || identifier != nil {
                self.scan(nil, options: nil, peripheral: identifier)
            }
        case .poweredOff:
            // TODO: 测试流程
            
            // 查看设备的断开
        break
        case .unauthorized:
            // TODO: 等待验证
            break
        default:
            debugPrint("===开关异常")
            break
        }
    }

    
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    } 
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let identifier = self.waitToConnectPeripheral,
           let uuid = UUID(uuidString: identifier) {
            if peripheral.identifier == uuid {
                central.stopScan()
                self.connect(peripheral, options: nil)
            }
        } else {
            NotificationCenter.default.post(name: BluetoothManager.didReceivedAdvertisement, object: peripheral, userInfo: ["data": advertisementData, "rssi": RSSI])
        }
    }
    // connect api success
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // 取消超时等待
    }

    // connect api failed
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // 取消超时等待
    }
    // Deallocating peripheral 解除分配也会引起 cancelPeripheralConnection
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if error == nil { // 用户主动断开连接的
            // 发通知
        } else {
            let services: [CBUUID] = peripheral.services?.map(\.uuid) ?? []
            retrievePeripheral(peripheral.identifier, services: services)
        }
    }
}
// connect
public extension BluetoothManager {
    
}
