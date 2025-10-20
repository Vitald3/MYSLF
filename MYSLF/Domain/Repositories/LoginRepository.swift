//
//  LoginRepository.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import Foundation

protocol LoginRepositoryProtocol {
    func saveAuthToken(_ token: String, _ provider: String)
    var isTokenEmpty: Bool { get }
    func register(_ uuid: String) async -> Result<User, NetworkError>
}
