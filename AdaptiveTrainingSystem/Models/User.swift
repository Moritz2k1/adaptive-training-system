//
//  User.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 06.06.26.
//

import SwiftData
import Foundation

// SwiftData model - stored locally in app's db

class User {
    var id: UUID
    var username: String
    var email: String
    var password: String
    var createdAt: Date
}
