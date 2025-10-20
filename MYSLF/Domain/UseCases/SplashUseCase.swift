//
//  SplashUseCase.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

protocol SplashUseCaseProtocol {
    var tokenIsEmpty: Bool { get }
}

final class SplashUseCase: SplashUseCaseProtocol {
    private let repository: LoginRepositoryProtocol

    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }

    var tokenIsEmpty: Bool {
        repository.isTokenEmpty
    }
}
