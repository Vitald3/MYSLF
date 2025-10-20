//
//  TakedClient.swift
//  MYSLF
//
//  Created by Vitald3 on 20.10.2025.
//

import Foundation
import UIKit

protocol TakedClientProtocol {
    func getClosest(_ image: Data) async throws -> String?
}

final class TakedClient: TakedClientProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getClosest(_ image: Data) async throws -> String? {
        guard let url = URL(string: Endpoint.takedClosest) else {
            throw URLError(.badURL)
        }
        
        let (data, code) = try await apiClient.upload(
            endpoint: url,
            method: "POST",
            fields: [:],
            fileData: image,
            fileName: "closest.jpg",
            mimeType: "image/jpeg",
            fieldName: "file"
        )
        
        let response = try JSONDecoder().decode(String.self, from: data)
        
        if code == 200 {
            return response
        } else {
            throw NSError(domain: "nckr", code: code, userInfo: [
                NSLocalizedDescriptionKey: "Error"
            ])
        }
    }
}
