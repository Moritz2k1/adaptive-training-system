//
//  CoreBluetoothService.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 05.06.26.
//

import CoreBluetooth
import Combine

class CoreBluetoothService : NSObject, ObservableObject, HeartRateService {
    
    // Constants - UUIDs
    private let HEART_RATE_SERVICE = CBUUID(string: "180D")
    private let BT_CHARACTERISTIC = CBUUID(string: "2A37")
    
    // Variables
    private var centralManager : CBCentralManager!
    private var peripheral : CBPeripheral?
    
    // Observables in the UI
    @Published private(set) var statusText: String = "Ready"
    @Published private(set) var heartRate: Int = 0
    @Published private(set) var rrIntervals: [Double] = []
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var isScanning: Bool = false
    
    // Publisher Conformance -> Must be used because of Protocol
    var heartRatePublisher: AnyPublisher<Int, Never> { $heartRate.eraseToAnyPublisher() }
    var rrIntervalsPublisher: AnyPublisher<[Double], Never> { $rrIntervals.eraseToAnyPublisher() }
    var isConnectedPublisher: AnyPublisher<Bool, Never> { $isConnected.eraseToAnyPublisher() }
    
    override init() {
        super .init()
        
        // Starts Core Bluetooth
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            statusText = "Bluetooth not powered on"
            return
        }
        
        isScanning = true
        statusText = "Searching for device..."
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

extension CoreBluetoothService: CBCentralManagerDelegate {
    
    // Called when Bluetooth status changes
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            statusText = "Bluetooth ready"
        case .poweredOff:
            statusText = "Bluetooth powered off"
        case .unauthorized:
            statusText = "Bluetooth not authorized"
        default:
            statusText = "Bluetooth not available"
        }
    }
    
    // Called when device has been found
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        
        // Guard constant for peripheral name
        guard let peripheralName = peripheral.name, Configuration.supportedDevices.contains(where: { device in peripheralName.contains(device) }) else { return }
        
        self.peripheral = peripheral
        statusText = "Device found: \(peripheralName)"
        stopScanning()
        
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

extension CoreBluetoothService: CBPeripheralDelegate {
    
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
