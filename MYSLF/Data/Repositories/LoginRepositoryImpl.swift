//
//  OnboardingRepositoryImpl.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import Foundation

final class LoginRepositoryImpl: LoginRepositoryProtocol {
    let client: LoginClientProtocol
    let storage: UserDefaultsStorage
    let tokenStorage: TokenStorage
    
    init(client: LoginClientProtocol, storage: UserDefaultsStorage, tokenStorage: TokenStorage) {
        self.client = client
        self.storage = storage
        self.tokenStorage = tokenStorage
    }
    
    func saveAuthToken(_ token: String, _ provider: String) {
        storage.set(token, forKey: "auth_\(provider)")
    }
    
    var isTokenEmpty: Bool {
        (storage.get(String.self, forKey: "apple") ?? "").isEmpty
        || (storage.get(String.self, forKey: "google") ?? "").isEmpty
    }
    
    func register(_ uuid: String) async -> Result<User, NetworkError> {
        let body: [String: Any] = ["uuid": uuid]
        
        do {
            let response: RegisterDeviceResponse? = try await client.register(body)
            
            if let result = response?.user, let token = response?.token {
                tokenStorage.saveToken(token)
                return .success(result)
            } else {
                return .failure(.unknown("Validate error"))
            }
        } catch let error as NSError {
            return .failure(error as! NetworkError)
        }
    }
}
