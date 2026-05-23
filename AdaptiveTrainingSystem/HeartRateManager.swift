//
//  HeartRate.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 23.05.26.
//

import CoreBluetooth
import Combine

class HeartRateManager: NSObject {
    
    // Constants
    let HEART_RATE = CBUUID(string: "180D")
    let BT_CHARACTERISTIC = CBUUID(string: "2A37")
    
    // Variables
    private var centralManager : CBCentralManager!
    private var polarH10 : CBPeripheral?
    
    // Observables in the UI
    @Published var statusText = "Ready"
    @Published var heartRate: Int?
    @Published var rrInterval: [Double] = []
    @Published var isConnected: Bool = false
    @Published var isScanning: Bool = false
    
    override init() {
        super .init()
        
        // Starts Core Bluetooth
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
}

extension HeartRateManager: CBCentralManagerDelegate {
    
    // Called when Bluetooth status changes
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            statusText = "Bluetooth ready"
        case .poweredOff:
            statusText = "Bluetooth powered off"
        case .unauthorized:
            statusText = "Bluetooth not authorized"
        case .unsupported:
            statusText = "Bluetooth unsupported"
        default:
            statusText = "Bluetooth not available"
        }
    }
    
    // Called when device has been found
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        // Guard constant for name
        guard let peripheralName = peripheral.name, peripheralName.contains("Polar H10") else { return }
        
        statusText = "H10 found: \(peripheralName)"
        polarH10 = peripheral
        centralManager.stopScan()
        
        // Direct connection
        centralManager.connect(peripheral)
    }
    
    // Connection successful
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        statusText = "Connected"
        isConnected = true
        peripheral.delegate = self
        
        // Search for HR Services
        peripheral.discoverServices([HEART_RATE])
    }
    
    // Disconnect - reset values
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        statusText = "Disconnected"
        isConnected = false
        heartRate = 0;
        rrInterval = []
    }
}

extension HeartRateManager: CBPeripheralDelegate {
    
    // Service found
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        
        // All services
        guard let services = peripheral.services else { return }
        
        // Iterate over services
        for service in services {
            if (service.uuid == HEART_RATE) {
                peripheral.discoverCharacteristics([BT_CHARACTERISTIC], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        
        // All characteristics
        guard let characteristics = service.characteristics else { return }
        
        // Iterate over characteristics
        for characteristic in characteristics {
            if (characteristic.uuid == BT_CHARACTERISTIC) {
                // Activate notifications
                peripheral.setNotifyValue(true, for: characteristic)
                statusText = "Heart Rate Stream active"
            }
        }
    }
}
