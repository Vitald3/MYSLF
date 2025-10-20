//
//  NetworkError.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case networkError(code: Int, description: String)
    case serverError(code: Int, message: String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .networkError(_, let description): return description
        case .serverError(_, let message): return message
        case .unknown(let msg): return msg
        }
    }

    var code: Int? {
        switch self {
        case .networkError(let code, _): return code
        case .serverError(let code, _): return code
        default: return nil
        }
    }
}
