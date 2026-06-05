//
//  ContentView.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 20.05.26.
//

import SwiftUI

struct ContentView: View {
    
    // Get class
    @StateObject var HRManager = HeartRateService()
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Polar H10").font(.title).bold()
            
            // Show status
            Text(HRManager.statusText)
                .foregroundColor(.secondary).multilineTextAlignment(.center)
            
            // Heart Rate
            if (HRManager.heartRate > 0) {
                VStack(spacing: 8) {
                    Text("\(HRManager.heartRate)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.red)
                    Text("bpm")
                        .foregroundColor(.secondary)
                }
                
                // RR-Intervals
                if (!HRManager.rrIntervals.isEmpty) {
                    Text("RR: \(HRManager.rrIntervals.map { Int($0)}.description) ms")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
            }
            
            if (!HRManager.isConnected) {
                Button(HRManager.isScanning ? "Searching..." : "Search for H10") {
                    HRManager.startScanning()
                }
                .buttonStyle(.borderedProminent)
                .disabled(HRManager.isScanning)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
