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

class AuthService: ObservableObject {
    
    private let modelContext: ModelContext
    
    // Currently logged in user
    @Published private(set) var currentUser: User?
    
    // Nil means logged out
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // SHA256 hash
    private func hash(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func persistSession(userID: UUID) {
        UserDefaults.standard.set(userID.uuidString, forKey: "currentUserID")
    }
    
    // Restore session after app restart
    private func restoreSession() {
        guard let idString = UserDefaults.standard.string(forKey: "currentUserID"),
              let uuid = UUID(uuidString: idString) else { return }
        
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.id == uuid }
        )
        
        currentUser = try? modelContext.fetch(descriptor).first
    }
    
    func register(username: String, email: String, password: String) throws {
        
        // Check if email is already taken
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email }
        )
        
        let existingUser = try modelContext.fetch(descriptor)
        guard existingUser.isEmpty else { throw AuthError.emailAlreadyExists }
        
        let user = User(username: username, email: email, password: hash(password))
        modelContext.insert(user)
        try modelContext.save()
        
        currentUser = user
        persistSession(userID: user.id)
    }
    
    func login(email: String, password: String) throws {
        
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email }
        )
        
        let users = try modelContext.fetch(descriptor)
        
        guard let user = users.first else { throw AuthError.userNotFound }
        guard user.password == hash(password) else { throw AuthError.wrongPassword }
        
        currentUser = user
        persistSession(userID: user.id)
    }
    
    func logout() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "currentUserID")
    }
}
