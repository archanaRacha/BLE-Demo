//
//  ContentView.swift
//  BLE-Demo
//
//  Created by archana racha on 01/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BLEViewModel()
    var body: some View {
        NavigationView{
            List(viewModel.devices){ device in
                HStack{
                    Text(device.name)
                        .font(.headline)
                    Spacer()
                    Text("RSSI: \(device.rssi)")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
             

                
            }
            .navigationTitle("Nearby BLE Devices")
            .refreshable {
                viewModel.scan()
            }
            
            
        }
    }
}

#Preview {
    ContentView()
}
