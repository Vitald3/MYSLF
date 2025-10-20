//
//  AuthClient.swift
//  NCKR
//
//  Created by Vitald3 on 02.08.2025.
//

import Foundation
import UIKit

protocol LoginClientProtocol {
    func register(_ body: [String: Any]) async throws -> RegisterDeviceResponse?
}

final class LoginClient: LoginClientProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func register(_ body: [String: Any]) async throws -> RegisterDeviceResponse? {
        guard let url = URL(string: Endpoint.register) else {
            throw URLError(.badURL)
        }
        
        let (data, code) = try await apiClient.request(
            endpoint: url,
            method: "POST",
            body: body
        )
        
        let response = try JSONDecoder().decode(RegisterDeviceResponse.self, from: data)
        
        if code == 200 {
            return response
        } else {
            throw NSError(domain: "nckr", code: code, userInfo: [
                NSLocalizedDescriptionKey: "Error"
            ])
        }
    }
}
