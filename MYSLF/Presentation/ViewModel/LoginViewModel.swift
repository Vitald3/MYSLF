//
//  OnboardingViewModel.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import Foundation
import SwiftUI
import Combine
import AuthenticationServices

@MainActor
class LoginViewModel: ObservableObject {
    private let router: NavigationRouter
    private let useCase: LoginUseCaseProtocol
    
    init(router: NavigationRouter, useCase: LoginUseCaseProtocol) {
        self.router = router
        self.useCase = useCase
    }
    
    func startAppleLogin() {
        Task {
            do {
                let token = try await useCase.executeAppleSignIn()
                
                if !token.accessToken.isEmpty {
                    router.replace(.welcome)
                }
            } catch {
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
    
    func startGoogleLogin() {
        Task {
            do {
                let token = try await useCase.signInWithGoogle()
                
                if !token.accessToken.isEmpty {
                    router.replace(.welcome)
                }
            } catch {
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
}
