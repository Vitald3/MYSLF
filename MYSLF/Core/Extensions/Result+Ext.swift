//
//  Result.swift
//  NCKR
//
//  Created by Vitald3 on 29.08.2025.
//

import Foundation

extension Result {
    static func failure(from error: Error) -> Result<Success, NetworkError> {
        if let nsError = error as NSError?,
           nsError.domain == NSURLErrorDomain {
            return .failure(.networkError(
                code: nsError.code,
                description: nsError.localizedDescription
            ))
        }
        
        if let nsError = error as NSError? {
            return .failure(.serverError(
                code: nsError.code,
                message: nsError.localizedDescription
            ))
        }
        
        return .failure(.unknown(error.localizedDescription))
    }
}
