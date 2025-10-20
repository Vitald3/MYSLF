//
//  OnboardingViewModel.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    private let router: NavigationRouter
    private let useCase: OnboardingUseCaseProtocol
    @Published var isNotify: Bool = false
    
    init(router: NavigationRouter, useCase: OnboardingUseCaseProtocol) {
        self.router = router
        self.useCase = useCase
        
        Task {
            isNotify = await useCase.checkNotificationPermission()
        }
    }
    
    func register() {
        Task {
            let result = await useCase.register(Helper.deviceID)
            
            switch result {
            case .success(let user):
                router.replace(.home, with: user)
            case .failure(let error):
                router
                    .showDialog(
                        title: "Error",
                        message: error.localizedDescription,
                        actions: [
                            .init(title: "Ок", role: .destructive, action: nil)
                        ]
                    )
            }
        }
    }
    
    func getClosest(_ image: UIImage) async -> String? {
        let result = await useCase.getClosest(image)
        
        switch result {
        case .success(let zone):
            return zone
        case .failure(let error):
            router
                .showDialog(
                    title: "Error",
                    message: error.localizedDescription,
                    actions: [
                        .init(title: "Ок", role: .destructive, action: nil)
                    ]
                )
            
            return nil
        }
    }
}
