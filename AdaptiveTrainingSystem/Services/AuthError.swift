//
//  AuthError.swift
//  AdaptiveTrainingSystem
//
//  Created by Moritz Gutschi on 06.06.26.
//

import Foundation

enum AuthError: LocalizedError {
    case emailAlreadyExists
    case userNotFound
    case wrongPassword
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyExists: return "An account with this email already exists"
        case .userNotFound: return "No account found with this email"
        case .wrongPassword: return "Incorrect password"
        case .unknown: return "An unknown error occurred"
        }
    }
}
