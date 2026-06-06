//
//  ContentView.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 20.05.26.
//

import SwiftUI

struct ContentView : View {
    
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        // Show auth flow or app based on login state
        if (authService.isLoggedIn) {
            ZoneSelectionView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
