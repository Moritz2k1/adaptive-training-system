//
//  Configuration.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 05.06.26.
//
import Foundation

struct Configuration {
    
    // BLE Supported Devices
    static let supportedDevices: [String] = ["Polar", "Garmin"]
    
    // Training
    static let age: Int = 25
    
    // In Seconds
    static let feedbackInterval: TimeInterval = 10
}
