//
//  Feedback.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 05.06.26.
//

import AVFoundation
import Combine

// Evaluates heart rate against target zone and delivers audio feedback
class Feedback : ObservableObject {
    
    // Properties
    // Converts text to speech
    private let synthesizer = AVSpeechSynthesizer()
    
    // Tracks when last feedback was given
    private var lastFeedback: Date = .distantPast
    
    // Compares current HR against zone boundaries and triggers audio feedback
    func evaluate(currentHeartRate: Int, zone: TrainingZone, userMaxHeartRate: Int) {
        
        // Compute absolute BPM boundaries for selected zone
        let zoneMin = zone.minHeartRate(userMaxHeartRate: userMaxHeartRate)
        let zoneMax = zone.maxHeartRate(userMaxHeartRate: userMaxHeartRate)
        
        // Skip if no HR signal yet
        guard currentHeartRate > 0 else { return }
        
        // Enforce cooldown to avoid repeated feedback
        guard Date().timeIntervalSince(lastFeedback) >= Configuration.feedbackInterval else { return }
        
        // Trigger audio feedback if not in selected zone
        if (currentHeartRate < zoneMin) {
            speak("Faster")
        }
        else if (currentHeartRate > zoneMax) {
            speak("Slower")
        }
    }
    
    // Speaks given message and updates cooldown timer
    private func speak(_ message: String) {
        let speech = AVSpeechUtterance(string: message)
        speech.voice = AVSpeechSynthesisVoice(language: "en-US")
        speech.rate = 0.45
        speech.volume = 1.0
        synthesizer.speak(speech)
        lastFeedback = Date()
    }
}
