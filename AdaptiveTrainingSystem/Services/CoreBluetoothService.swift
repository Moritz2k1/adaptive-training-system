//
//  CoreBluetoothService.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 05.06.26.
//

import CoreBluetooth
import Combine

class CoreBluetoothService : NSObject, HeartRateService, ObservableObject {
    
    // Constants
    let HEART_RATE_SERVICE = CBUUID(string: "180D")
    let BT_CHARACTERISTIC = CBUUID(string: "2A37")
    
    // Variables
    private var centralManager : CBCentralManager!
    private var peripheral : CBPeripheral?
    
    // Observables in the UI
    @Published var statusText: String = "Ready"
    @Published var heartRate: Int = 0
    @Published var rrIntervals: [Double] = []
    @Published var isConnected: Bool = false
    @Published var isScanning: Bool = false
    
    override init() {
        super .init()
        
        // Starts Core Bluetooth
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            statusText = "Bluetooth not powered on"
            return
        }
        
        isScanning = true
        statusText = "Searching for Polar H10"
        // Only look for devices with HR services
        centralManager.scanForPeripherals(withServices: [HEART_RATE_SERVICE])
    }
    
    func stopScanning() {
        centralManager.stopScan()
        isScanning = false
    }
    
    // Calculate RR-Intervals
    private func parseHeartRateData(_ data: Data) {
        let flags = data[0]
        
        // Bit 0 determines if HR is saved as UInt8 or UInt16
        let hrFormat16Bit = (flags & 0x01) != 0
        let hrValue: Int
        
        if hrFormat16Bit {
            hrValue = Int(data[1]) | Int(data[2]) << 8
        } else {
            hrValue = Int(data[1])
        }
        
        heartRate = hrValue
        
        // Bit 4 determines RR-Intervals
        let rrThere = (flags & 0x10) != 0
        guard rrThere else { return }
        
        // RR=Intervalls start after HR
        let rrOffset = hrFormat16Bit ? 3 : 2
        var rrs: [Double] = []
        var i = rrOffset
        
        while (i+1 < data.count) {
            // Convert to ms
            let rrRaw = Int(data[i]) | Int(data[i+1]) << 8
            let rrMS = Double(rrRaw) / 1024.0 * 1000.0
            rrs.append(rrMS)
            i += 2
        }
        
        rrIntervals = rrs
        print("HR: \(hrValue) bpm | RR: \(rrs.map { Int($0) }) ms")
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
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        
        // Guard constant for name
        guard let peripheralName = peripheral.name, peripheralName.contains("Polar H10") else { return }
        
        statusText = "H10 found: \(peripheralName)"
        peripheral = peripheral
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
        peripheral.discoverServices([HEART_RATE_SERVICE])
    }
    
    // Disconnect - reset values
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        statusText = "Disconnected"
        isConnected = false
        heartRate = 0;
        rrIntervals = []
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
            if (service.uuid == HEART_RATE_SERVICE) {
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
    
    // Received new data
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard characteristic.uuid == BT_CHARACTERISTIC,
        let newData = characteristic.value else { return }
        parseHeartRateData(newData)
    }
}
