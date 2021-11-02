//
//  APIError.swift
//  Builder
//
//  Created by Michael Long on 1/18/21.
//

import Foundation

enum APIError: Error {
    case application
    case connection
    case server
    case unknown
    case unexpected
}

extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .connection:
            return "Unable to connect to server at this time."
        case .unknown:
            return "An unknown error occurred."
        default:
            return "An unexpected error occurred."
        }
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        return self.description
    }
}
