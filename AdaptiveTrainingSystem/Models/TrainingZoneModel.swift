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
}
