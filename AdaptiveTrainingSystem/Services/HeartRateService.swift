//
//  HeartRate.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 23.05.26.
//
import Combine

// Defines blueprint for HeartRateService
protocol HeartRateService : AnyObject {
    
    var heartRate: Int { get }
    var rrIntervals: [Double] { get }
    var isConnected: Bool { get }
    var statusText: String { get }
    var isScanning: Bool { get }
    
    // Publisher for reactive Updates in UI
    var heartRatePublisher: AnyPublisher<Int, Never> { get }
    var rrIntervalsPublisher: AnyPublisher<[Double], Never> { get }
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
    
    func startScanning()
    func stopScanning()
}
