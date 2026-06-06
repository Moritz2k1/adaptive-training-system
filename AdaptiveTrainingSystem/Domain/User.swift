//
//  User.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 06.06.26.
//

import SwiftData
import Foundation

// SwiftData model - stored locally in app's db
@Model
class User {
    var id: UUID
    var username: String
    var email: String
    var password: String
    var createdAt: Date
    
    init(username: String, email: String, password: String) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.password = password
        self.createdAt = Date()
    }
}
