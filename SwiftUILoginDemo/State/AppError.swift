//
//  AppError.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/14.
//

import Foundation

//配合SwiftUI的alert使用，需要Identifiable
enum AppError: Error, Identifiable {
    var id: String { localizedDescription }

    case emailError
    case passwordError
    case differentPasswordError
    
    case serverError(code: Int, message: String)
    case networkingFailed(Error)
    case decodingError(Error)
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .emailError:
            return "Please enter a valid email."
        case .passwordError:
            return "Your password must be between 6 - 20 characters long. Contain letters and numbers."
        case .differentPasswordError:
            return "Your verify password must be the same as password."
        case .serverError(let code, let message):
            return "Server error: \(code) \(message)"
        case .networkingFailed(let error):
            return error.localizedDescription
        case .decodingError(let error):
            return error.localizedDescription
        }
    }
}
