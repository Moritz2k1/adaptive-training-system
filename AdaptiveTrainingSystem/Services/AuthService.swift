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
}
