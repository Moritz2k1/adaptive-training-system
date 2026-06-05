//
//  ZoneSelectionView.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 05.06.26.
//

import SwiftUI

struct ZoneSelectionView : View {
    
    // User's age
    @State private var age = Configuration.age
    
    // Current selected training zone (default is zone 2)
    @State private var selectedZone = TrainingZoneModel.ZoneModels[1]
    
    // Estimated max HR using following formula: 220 - age
    var userMaxHeartRate: Int { 220 - age }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Age input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Age")
                        .font(.headline)
                    
                    // Stepper bounded to realistic age range
                    Stepper("\(age) years old", value: $age, in: 12...90)
                    
                    // Shows computed max HR, updates live as age changes
                    Text("Max Heart Frequency: \(userMaxHeartRate) bpm")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Select Zone
                VStack(alignment: .leading, spacing: 12) {
                    Text("Training Zone")
                        .font(.headline)
                    
                    // Renders a row for each available training zone
                    ForEach(TrainingZoneModel.ZoneModels) {
                        zone in HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                
                                // Zone name and description
                                Text("\(zone.name) - \(zone.description)")
                                    .font(.subheadline)
                                    .bold()
                                
                                // Absolute BPM range - updates when age changes
                                Text("\(zone.minHeartRate(userMaxHeartRate: userMaxHeartRate)) - \(zone.maxHeartRate(userMaxHeartRate: userMaxHeartRate)) bpm")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Checkmark shown only for selected zone
                            if (selectedZone.id == zone.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture { selectedZone = zone }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                    
                Spacer()
                
                NavigationLink {
                    TrainingView(zone: selectedZone, userMaxHeartRate: userMaxHeartRate)
                } label: {
                    Text("Start Training")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
                .padding()
            .navigationTitle("Setup")
        }
    }
}
