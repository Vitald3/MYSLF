//
//  TakedRepositoryImpl.swift
//  MYSLF
//
//  Created by Vitald3 on 20.10.2025.
//

import Foundation

final class TakedRepositoryImpl: TakedRepositoryProtocol {
    let client: TakedClientProtocol
    
    init(client: TakedClientProtocol) {
        self.client = client
    }
    
    func getClosest(_ image: Data) async -> Result<String, NetworkError> {
        do {
            let response: String? = try await client.getClosest(image)
            
            if let result = response {
                return .success(result)
            } else {
                return .failure(.unknown("Validate error"))
            }
        } catch let error as NSError {
            return .failure(error as! NetworkError)
        }
    }
}
