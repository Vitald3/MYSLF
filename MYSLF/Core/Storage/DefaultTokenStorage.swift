//
//  DefaultTokenStorage.swift
//  MySecureX
//
//  Created by Vitald3 on 18.07.2025.
//

protocol TokenStorageProtocol {
    func saveToken(_ token: String)
    func deleteToken()
}

final class TokenStorage: TokenStorageProtocol {
    private let storage: KeychainStorage
    
    init(storage: KeychainStorage) {
        self.storage = storage
    }
    
    func saveToken(_ token: String) {
        try? storage.save(token, for: "token")
    }
    
    func deleteToken() {
        try? storage.delete("token")
    }
}
