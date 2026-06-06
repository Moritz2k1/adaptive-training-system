//
//  RegisterView.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 06.06.26.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
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
            
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
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
            
            if (!errorMessage.isEmpty) {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            Button("Create account") {
                do {
                    try authService.register(username: username, email: email, password: password)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .disabled(!isFormValid)
            
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
