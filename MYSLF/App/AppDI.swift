//
//  AppDI.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import Foundation
import SwiftUI

final class AppDI {
    static let shared = AppDI()
    let router = NavigationRouter()
    
    // MARK: - Services
    lazy var pushService: PushService = DefaultPushService()

    // MARK: - Network
    private let apiClient: APIClientProtocol

    // MARK: - Storage
    lazy var storage = UserDefaultsStorage()
    lazy var keychain = KeychainStorage()
    lazy var tokenStorage: TokenStorage = TokenStorage(storage: keychain)

    // MARK: - Clients
    lazy var loginClient: LoginClientProtocol = LoginClient(apiClient: apiClient)

    // MARK: - Data Repositories
    lazy var loginRepositoryImpl: LoginRepositoryProtocol = LoginRepositoryImpl(client: loginClient, storage: storage, tokenStorage: tokenStorage)
    lazy var takedRepositoryImpl: TakedRepositoryProtocol = TakedRepositoryImpl(client: loginClient)

    // MARK: - Use Cases
    lazy var loginUseCase: LoginUseCase = LoginUseCase(repository: loginRepositoryImpl)
    lazy var splashUseCase: SplashUseCase = SplashUseCase(repository: loginRepositoryImpl)
    lazy var onboardingUseCase: OnboardingUseCase = OnboardingUseCase(
        repository: loginRepositoryImpl,
        takedRepository: takedRepositoryImpl
    )
    lazy var cameraUseCase: CameraUseCase = CameraUseCase()

    // MARK: - Init
    private init() {
        self.apiClient = APIClient()
    }
}
