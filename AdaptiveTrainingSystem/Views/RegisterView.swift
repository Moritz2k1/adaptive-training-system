//
//  RegisterView.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 06.06.26.
//

import SwiftUI

struct RegisterView: View {
    
    // Auth service injected from environment
    // Handles registration logic
    @EnvironmentObject var authService: AuthService
    
    // Used to navigate back to LoginView when user already has an account
    @Environment(\.dismiss) var dismiss
    
    // States
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Used for error messages from failed registration
    @State private var errorMessage = ""
    
    // All fields must be filled
    // Password must be at least 6 characters and match confirmation
    private var isFormValid: Bool {
        !username.isEmpty &&
        !email.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Create account")
                .font(.title)
                .bold()
                .padding(.bottom, 8)
            
            // Username field
            // No autocorrect and capitalization
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            // Email field
            // Numeric keyboard layout
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            // Pasword fields
            // SecureField hides input characters
            SecureField("Password (min 6 characters)", text: $password)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Confirm password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
            
            // Password mismatch
            if (!confirmPassword.isEmpty && password != confirmPassword) {
                Text("Passwords do not match")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // Error message from failed registration attempt
            if (!errorMessage.isEmpty) {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            // Registration button
            // Disabled until all fields pass validation
            Button("Create account") {
                do {
                    try authService.register(username: username, email: email, password: password)
                } catch {
                    // Surface error from AuthService to user
                    errorMessage = error.localizedDescription
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .disabled(!isFormValid)
            
            // Navigates back to LoginView
            Button("Already have an account? Log in") {
                dismiss()
            }
            .font(.footnote)
            .foregroundColor(.secondary)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
