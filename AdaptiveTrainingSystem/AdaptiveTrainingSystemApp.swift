//
//  AdaptiveTrainingSystemApp.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 20.05.26.
//

import SwiftUI
import SwiftData

@main
struct AdaptiveTrainingSystemApp: App {
    
    // Constants for local database
    let container: ModelContainer
    let authService: AuthService
    
    init() {
        do {
            // Set up local database
            container = try ModelContainer(for: User.self)
            authService = AuthService(modelContext: container.mainContext)
        } catch {
            fatalError("Failed to create database: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .environmentObject(authService)
        }
    }
}
