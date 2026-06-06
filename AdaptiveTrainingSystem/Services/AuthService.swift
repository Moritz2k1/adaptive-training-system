//
//  AuthService.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 06.06.26.
//

import Combine
import Foundation
import CryptoKit
import SwiftData

// Handles authentication
// Data stored on phone via SwiftData
class AuthService: ObservableObject {
    
    // Used to read and write User records
    private let modelContext: ModelContext
    
    // Currently logged in user
    @Published private(set) var currentUser: User?
    
    // Nil means logged out
    // Check used in ContentView to gate access to app
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        // Attempt to restore previous session on app launch
        restoreSession()
    }
    
    // SHA256 hash
    private func hash(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    // Saves logged-in user's ID to UserDefaults -> session survives app restarts
    private func persistSession(userID: UUID) {
        UserDefaults.standard.set(userID.uuidString, forKey: "currentUserID")
    }
    
    // Restore session after app restart
    private func restoreSession() {
        
        // Reads saved user ID from UserDefaults and fetches matching User from db
        guard let idString = UserDefaults.standard.string(forKey: "currentUserID"),
              let uuid = UUID(uuidString: idString) else { return }
        
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.id == uuid }
        )
        
        currentUser = try? modelContext.fetch(descriptor).first
    }
    
    // Creates new user account and logs them in immediately
    func register(username: String, email: String, password: String) throws {
        
        guard try fetchUser(email: email) == nil else { throw AuthError.emailAlreadyExists }
        
        // Create and persist new user with hashed pw
        let user = User(username: username, email: email, password: hash(password))
        
        modelContext.insert(user)
        try modelContext.save()
        
        // Log in immediately after registration
        currentUser = user
        persistSession(userID: user.id)
    }
    
    // Validates credentials against local database and logs user in
    func login(email: String, password: String) throws {
        
        guard let user = try fetchUser(email: email) else { throw AuthError.userNotFound }
        
        // Compare hashed input against stored hash
        guard user.password == hash(password) else { throw AuthError.wrongPassword }
        
        currentUser = user
        persistSession(userID: user.id)
    }
    
    // Clears current session both in memory and UserDefaults
    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "currentUserID")
    }
    
    private func fetchUser(email: String) throws -> User? {
        // Query local database for existing user
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email }
        )
        return try modelContext.fetch(descriptor).first
    }
}
