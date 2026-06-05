//
//  Feedback.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 05.06.26.
//

import AVFoundation
import Combine

class Feedback : ObservableObject {
    
    private let synthesizer = AVSpeechSynthesizer()
    private var lastFeedback: Date = .distantPast
    
    func evaluate(currentHeartRate: Int, zone: TrainingZoneModel, userMaxHeartRate: Int) {
        
        let zoneMin = zone.minHeartRate(userMaxHeartRate: userMaxHeartRate)
        let zoneMax = zone.maxHeartRate(userMaxHeartRate: userMaxHeartRate)
        
        guard currentHeartRate > 0 else { return }
    }
}
