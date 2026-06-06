//
//  LoginView.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 06.06.26.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authService: AuthService
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var goToRegister: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Welcome!")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 8)
                
                // Email
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                // Password
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                // Error
                if (!errorMessage.isEmpty) {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                // Login Button
                Button("Log in") {
                    do {
                        try authService.login(email: email, password: password)
                    } catch {
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
        }
    }
}
