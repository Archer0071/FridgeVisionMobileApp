//
//  BluetoothManager.swift
//  FridgeVision
//
//  Created by Melanie Herbert on 7/25/23.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var connectedDevices: [CBPeripheral] = []

    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func stopScanning() {
        centralManager.stopScan()
    }

    func connectToDevice(_ device: CBPeripheral) {
        centralManager.connect(device, options: nil)
    }

    func disconnectDevice(_ device: CBPeripheral) {
        centralManager.cancelPeripheralConnection(device)
    }

    // MARK: - CBCentralManagerDelegate Methods

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        // Handle Bluetooth state changes
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        // Filter out devices not named "raspberrypi".
        guard let deviceName = peripheral.name, deviceName.lowercased() == "raspberrypi" else { return }
        
        // Change RSSI value.
        let rssiDecreased = RSSI.intValue - 10
        
        print("Device \(deviceName) discovered. RSSI: \(rssiDecreased)")

        discoveredDevices.append(peripheral)
    }


    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        connectedDevices.append(peripheral)
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral: \(peripheral), error: \(error?.localizedDescription ?? "")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let index = connectedDevices.firstIndex(of: peripheral) {
            connectedDevices.remove(at: index)
        }
        connectedPeripheral = nil
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for _ in characteristics {
                // Handle discovered characteristics
            }
        }
    }
}
