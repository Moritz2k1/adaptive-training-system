//
//  ZoneSelectionView.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 05.06.26.
//

import SwiftUI

struct ZoneSelectionView : View {
    
    @State private var age = Configuration.age
    @State private var selectedZone = TrainingZoneModel.ZoneModels[1]
    
    var userMaxHeartRate: Int { 220 - age }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Age input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Age").font(.headline)
                    Stepper("\(age) years old", value: $age, in: 12...90)
                    Text("Max Heart Frequency: \(userMaxHeartRate) bpm").font(.caption).foregroundColor(.secondary)
                }.padding().background(Color(.systemGray6)).cornerRadius(12)
            }
        }
    }
}
