//
//  BLEViewModel.swift
//  BLE-Demo
//
//  Created by archana racha on 01/11/25.
//

import Foundation

class BLEViewModel :ObservableObject {
    @Published var devices: [Device] = []
    private var manager = BLEManager()
    init (){
        
        manager.$devices.assign(to:&$devices)
        if devices.isEmpty{
            manager.startScanning()
        }
    }
    func scan(){
        manager.stopScanning()
        manager.startScanning()
    }
   
   
    
}
