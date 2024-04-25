//
//  AppError.swift
//  Loadable-View-ViewModel
//
//  Created by Alex Lin Segarra on 25/4/24.
//

import Foundation

enum AppError: Error {
    case networkError(message: String)
    case notFound(message: String)
    case unauthorized(message: String)
    case genericError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .networkError(let message), .notFound(let message),
             .unauthorized(let message), .genericError(let message):
            return message
        }
    }
}
