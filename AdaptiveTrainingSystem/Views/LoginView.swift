//
//  LoginView.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 06.06.26.
//

import SwiftUI

struct LoginView: View {
    
    // Auth service injected from environment
    // Handles registration logic
    @EnvironmentObject var authService: AuthService
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    // Holds error messages from failed login attempt
    @State private var errorMessage: String = ""
    
    // Controls navigation to RegisterView
    @State private var goToRegister: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Welcome!")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 8)
                
                // Email field
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                // Password field
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                // Error message from failed login attempt
                if (!errorMessage.isEmpty) {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                // Login Button
                // Disabled until both fields are filled
                Button("Log in") {
                    do {
                        try authService.login(email: email, password: password)
                    } catch {
                        // Surface error from AuthService to user
                        errorMessage = error.localizedDescription
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(email.isEmpty || password.isEmpty)
                
                // Register link
                Button("No account yet? Register here") {
                    goToRegister = true
                }
                .font(.footnote)
                .foregroundColor(.secondary)
            }
            .padding()
            .navigationDestination(isPresented: $goToRegister) {
                RegisterView()
            }
        }
    }
}
