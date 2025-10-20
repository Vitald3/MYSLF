//
//  WelcomeUseCase.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

import UserNotifications
import UIKit

protocol OnboardingUseCaseProtocol {
    func register(_ uuid: String) async -> Result<User, NetworkError>
    func checkNotificationPermission() async -> Bool
    func getClosest(_ image: UIImage) async -> Result<String, NetworkError>
}

final class OnboardingUseCase: OnboardingUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    private let takedRepository: TakedRepositoryProtocol

    init(repository: LoginRepositoryProtocol, takedRepository: TakedRepositoryProtocol) {
        self.repository = repository
        self.takedRepository = takedRepository
    }

    func register(_ uuid: String) async -> Result<User, NetworkError> {
        await repository.register(uuid)
    }
    
    func checkNotificationPermission() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        default:
            return false
        }
    }
    
    func getClosest(_ image: UIImage) async -> Result<String, NetworkError> {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return .failure(.unknown("Get image data error"))
        }
        
        return await takedRepository.getClosest(imageData)
    }
}
