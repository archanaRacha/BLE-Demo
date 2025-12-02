//
//  BLEManager.swift
//  BLE-Demo
//
//  Created by archana racha on 01/11/25.
//

import Foundation
import CoreBluetooth


extension CBUUID {
    static func fromSigUUID(_ uuid16: UInt16) -> CBUUID {
        let bytes: [UInt8] = [
            UInt8((uuid16 >> 8) & 0xFF),
            UInt8(uuid16 & 0xFF)
        ]
        let data = Data(bytes)
        return CBUUID(data: data)
    }
}

class BLEManager:NSObject, ObservableObject,CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private let serviceUUID = CBUUID.init(string: "REPLACE WITH YOUR SERVICE UUID")//if we are searching for a particular device type and we know that device service UUID
    @Published var devices:[Device] = []
    private var centralManager:CBCentralManager!
    private var isScanning: Bool = false
    var isConnectedToDevice: Bool = false
    var connected_Device : Device?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
       guard centralManager.state == .poweredOn else {
           print("❌ Cannot start scan — Bluetooth not powered on yet.")
           return
       }

       if !isScanning {
           print("🔍 Starting BLE scan...")
           
           let r_service_UUID = serviceUUID
           let options = [CBCentralManagerScanOptionAllowDuplicatesKey:false]
           centralManager.scanForPeripherals(withServices: [r_service_UUID],options: options)
       }
    }

    func stopScanning() {
       if isScanning {
           print("🛑 Stopping BLE scan...")
           centralManager.stopScan()
           isScanning = false
       }
    }
    // MARK: - Connect / Disconnect
      func toggleConnection(for device: Device) {
          if device.isConnected {
              print("🔌 Disconnecting from \(device.name)")
              centralManager.cancelPeripheralConnection(device.peripheral)
          } else {
              print("⚡ Connecting to \(device.name)")
              device.peripheral.delegate = self
              centralManager.connect(device.peripheral, options: nil)
          }
      }

// MARK: - Discovery
   func centralManager(_ central: CBCentralManager,
                       didDiscover peripheral: CBPeripheral,
                       advertisementData: [String : Any],
                       rssi RSSI: NSNumber) {
       let name = peripheral.name ?? "Unknown Device"
       let newDevice = Device(peripheral: peripheral, name: name, rssi: RSSI)

       DispatchQueue.main.async {
           if !self.devices.contains(where: { $0.peripheral.identifier == peripheral.identifier }) {
               self.devices.append(newDevice)
           }
       }
   }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
               case .poweredOn:
                   print("✅ Bluetooth is ON — ready to scan.")
                   startScanning()
               case .poweredOff:
                   print("⚠️ Bluetooth is OFF — please enable it.")
               case .resetting:
                   print("Bluetooth resetting...")
               case .unauthorized:
                   print("Bluetooth unauthorized.")
               case .unsupported:
                   print("Bluetooth unsupported on this device.")
               case .unknown:
                   print("Bluetooth state unknown.")
               @unknown default:
                   print("A new Bluetooth state was added.")
               }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("✅ Connected to \(peripheral.name ?? "Device")")
        updateDeviceConnection(peripheral, isConnected: true)
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("❌ Disconnected from \(peripheral.name ?? "Device")")
        updateDeviceConnection(peripheral, isConnected: false)
    }

    private func updateDeviceConnection(_ peripheral: CBPeripheral, isConnected: Bool) {
        DispatchQueue.main.async {
            self.devices = self.devices.map { device in
                if device.peripheral.identifier == peripheral.identifier {
                    var updated = device
                    updated.isConnected = isConnected
                    return updated
                } else {
                    return device
                }
            }
        }
    }
}
