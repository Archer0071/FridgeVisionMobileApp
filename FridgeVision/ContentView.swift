//
//  ContentView.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/25/23.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @State private var isScanning = false

    var body: some View {
        TabView {
            BluetoothView(bluetoothManager: bluetoothManager, isScanning: $isScanning)
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Bluetooth")
                }
            
            InventoryView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Inventory")
                }
            
            PreferencesView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Preferences")
                }
        }
        .environmentObject(bluetoothManager)
    }
}

struct BluetoothView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @Binding var isScanning: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Color(UIColor.systemMint)
                    .frame(height: 120)
                    .edgesIgnoringSafeArea(.top)

                GeometryReader { geometry in
                    VStack {
                                                if bluetoothManager.discoveredDevices.isEmpty {
                                                    Spacer()

                                                    Text("No devices found")
                                                        .frame(maxWidth: .infinity)
                                                        .font(.headline)
                                                        .padding()
                                                        .background(Color.white)
                                                        .foregroundColor(.black)
                                                        .cornerRadius(10)
                                                        .padding()
                                                        .shadow(radius: 4)

                                                    Spacer()
                                                } else {
                                                    List(Array(bluetoothManager.discoveredDevices.enumerated()), id: \.element.identifier) { (index, device) in
                                                        NavigationLink(destination: DeviceDetailView(device: device)
                                                            .environmentObject(bluetoothManager)
                                                        ) {
                                                            Text(device.name ?? "Unknown Device")
                                                        }
                                                    }
                                                }

                                                NavigationLink(destination: VideoStreamingView()) {
                                                    Text("Live Stream")
                                                        .padding()
                                                        .background(Color.blue)
                                                        .foregroundColor(.white)
                                                        .cornerRadius(10)
                                                        .padding()
                                                        .shadow(radius: 4)
                                                }
                                                
                                                Button(action: {
                                                    if isScanning {
                                                        bluetoothManager.stopScanning()
                                                    } else {
                                                        bluetoothManager.startScanning()
                                                    }
                                                    isScanning.toggle()
                                                }) {
                                                    Text(isScanning ? "Stop Scanning" : "Scan for Devices")
                                                        .padding()
                                                        .background(Color.blue)
                                                        .foregroundColor(.white)
                                                        .cornerRadius(10)
                                                        .shadow(radius: 4)
                                                }
                                                .padding(.bottom, 100)
                                            }
                                            .padding()
                                        }
                                    }
                                    .background(Color.white)
                                    .edgesIgnoringSafeArea(.bottom)
                                    .navigationTitle("")
                                    .onAppear {
                                        bluetoothManager.startScanning()
                    
            }
        }
    }
}


struct InventoryView: View {
    @State private var inventory: [(item: String, quantity: Int)] = []
    @State private var addItemPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("CURRENT INVENTORY")
                    .font(.largeTitle)
                    .padding()
                    
                List {
                    ForEach(inventory.indices, id: \.self) { index in
                        HStack {
                            Text(inventory[index].item)
                            Spacer()
                            Text("\(inventory[index].quantity)")
                        }
                    }
                    .onDelete { indexSet in
                        inventory.remove(atOffsets: indexSet)
                    }
                }
                
                Button(action: {
                    addItemPresented.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("ADD FOOD")
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                .sheet(isPresented: $addItemPresented) {
                    AddItemView { item, quantity in
                        inventory.append((item: item, quantity: quantity))
                        addItemPresented = false
                    }
                }
            }
            .navigationTitle("Inventory")
            .navigationBarItems(leading: EditButton())
        }
    }
}

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var itemName = ""
    @State private var itemQuantity = 1
    
    var addItem: (String, Int) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item")) {
                    TextField("Name", text: $itemName)
                    Stepper("Quantity: \(itemQuantity)", value: $itemQuantity, in: 1...100)
                }
                
                Button("Add Item") {
                    addItem(itemName, itemQuantity)
                }
            }
            .navigationTitle("Add Item")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
