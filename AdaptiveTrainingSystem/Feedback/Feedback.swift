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
        
        // Check cooldown
        guard Date().timeIntervalSince(lastFeedback) >= Configuration.feedbackInterval else { return }
        
        if (currentHeartRate < zoneMin) {
            speak("Faster")
        }
        else if (currentHeartRate > zoneMax) {
            speak("Slower")
        }
    }
    
    private func speak(_ message: String) {
        let speech = AVSpeechUtterance(string: message)
        speech.voice = AVSpeechSynthesisVoice(language: "en-US")
        speech.rate = 0.45
        speech.volume = 1.0
        synthesizer.speak(speech)
        lastFeedback = Date()
    }
}
