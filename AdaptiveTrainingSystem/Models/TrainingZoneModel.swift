//
//  TrainingZoneModel.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 05.06.26.
//

import Foundation

struct TrainingZoneModel : Identifiable {
    let id: Int
    let name: String
    let description: String
    let minPercent: Double
    let maxPercent: Double
    
    func minHeartRate(userMaxHeartRate: Int) -> Int {
        Int(Double(userMaxHeartRate) * minPercent)
    }
    
    func maxHeartRate(userMaxHeartRate: Int) -> Int {
        Int(Double(userMaxHeartRate) * maxPercent)
    }
    
    static let ZoneModels: [TrainingZoneModel] = [
        // Zone 1
        TrainingZoneModel(
            id: 1,
            name: "Zone 1",
            description: "Recovery",
            minPercent: 0.5,
            maxPercent: 0.6
        ),
        
        // Zone 2
        TrainingZoneModel(
            id: 2,
            name: "Zone 2",
            description: "Endurance",
            minPercent: 0.6,
            maxPercent: 0.7
        ),
        
        // Zone 3
        TrainingZoneModel(
            id: 3,
            name: "Zone 3",
            description: "Aerobic",
            minPercent: 0.7,
            maxPercent: 0.8
        ),
        
        // Zone 4
        TrainingZoneModel(
            id: 4,
            name: "Zone 4",
            description: "Threshold",
            minPercent: 0.8,
            maxPercent: 0.9
        ),
        
        // Zone 5
        TrainingZoneModel(
            id: 5,
            name: "Zone 5",
            description: "Maximum",
            minPercent: 0.9,
            maxPercent: 1.0
        ),
    ]
}
