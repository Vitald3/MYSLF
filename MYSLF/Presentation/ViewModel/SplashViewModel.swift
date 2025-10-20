//
//  SplashViewModel.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

import Foundation
import Combine

@MainActor
class SplashViewModel: ObservableObject {
    private let useCase: SplashUseCaseProtocol
    
    init(useCase: SplashUseCaseProtocol) {
        self.useCase = useCase
    }
    
    var tokenIsEmpty: Bool {
        useCase.tokenIsEmpty
    }
}
