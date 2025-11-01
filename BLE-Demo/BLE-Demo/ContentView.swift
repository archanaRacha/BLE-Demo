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
                .contentShape(Rectangle()) // Makes whole row tappable
               .onTapGesture {
                   viewModel.toggleConnection(for: device)
               }
               .background(device.isConnected ? Color.green.opacity(0.1) : Color.clear)

                
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
