//
//  Device.swift
//  BLE-Demo
//
//  Created by archana racha on 01/11/25.
//

import Foundation
import CoreBluetooth

struct Device: Identifiable, Equatable {
    let id = UUID()
    let peripheral: CBPeripheral
    let name: String
    let rssi: NSNumber
    var isConnected: Bool = false

    static func == (lhs: Device, rhs: Device) -> Bool {
        lhs.peripheral.identifier == rhs.peripheral.identifier
    }
}
