//
//  TrainingView.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 05.06.26.
//

import SwiftUI

struct TrainingView : View {
    
    // Selected zone and max HR passed from ZoneSelectionView
    let zone: TrainingZoneModel
    let userMaxHeartRate: Int
    
    // Services
    
    // BLE service for HR data
    @StateObject private var hrService = CoreBluetoothService()
    
    // Audio feedback engine
    @StateObject private var feedback = Feedback()
    
    // Timer that triggers feedback evaluation every second
    @State private var timer: Timer?
    
    // Computed Properties
    
    // BPM boundaries for selected zone
    var zoneMin: Int { zone.minHeartRate(userMaxHeartRate: userMaxHeartRate) }
    var zoneMax: Int { zone.maxHeartRate(userMaxHeartRate: userMaxHeartRate) }
    
    /*
     HR indicator color
     Blue = too low
     Green = optimal
     Red = too high
     */
    var heartRateColor: Color {
        guard hrService.heartRate > 0 else { return .gray }
        if (hrService.heartRate < zoneMin) {
            return .blue
        }
        else if (hrService.heartRate > zoneMax) {
            return .red
        }
        else {
            return .green
        }
    }
    
    // Status label shown below HR value
    var statusLabel: String {
        guard hrService.heartRate > 0 else { return "Waiting for HR data"}
        if (hrService.heartRate < zoneMin) {
            return "Go faster"
        }
        else if (hrService.heartRate > zoneMax ) {
            return "Go slower"
        }
        else {
            return "Keep it up"
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            // Zone Info
            VStack(spacing: 4) {
                Text("\(zone.name) - \(zone.description)")
                    .font(.headline)
                Text("Target \(zoneMin) - \(zoneMax) bpm")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Heart Rate Display
            VStack(spacing: 4) {
                // Shows when no data is available yet
                Text(hrService.heartRate > 0 ? "\(hrService.heartRate)" : "--")
                    .font(.system(size: 90, weight: .bold))
                    .foregroundColor(heartRateColor)
                Text("bpm")
                    .foregroundColor(.secondary)
            }
            
            // Status
            Text(statusLabel)
                .font(.title3)
                .foregroundColor(heartRateColor)
            
            // BLE Status
            Text(hrService.statusText)
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Scan button, which is only visible when not connected
            if (!hrService.isConnected) {
                Button(hrService.isScanning ? "Searching..." : "Connect Device") {
                    hrService.startScanning()
                }
                .buttonStyle(.borderedProminent)
                .disabled(hrService.isScanning)
            }
        }
        .padding()
        .navigationTitle("Training")
        .navigationBarTitleDisplayMode(.inline)
    }
}
