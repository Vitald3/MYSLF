//
//  LoginUseCase.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import AuthenticationServices
import UIKit
import GoogleSignIn

enum AuthError: Error {
    case noAppleToken
    case noGoogleClientID
    case noGoogleToken
}

protocol LoginUseCaseProtocol {
    func executeAppleSignIn() async throws -> AuthToken
    func signInWithGoogle() async throws -> AuthToken
}

final class LoginUseCase: NSObject, LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    private var continuation: CheckedContinuation<AuthToken, Error>?

    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }

    func executeAppleSignIn() async throws -> AuthToken {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            startSignInWithApple()
        }
    }
    
    func signInWithGoogle() async throws -> AuthToken {
        guard let presenting = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
            .first else { throw AuthError.noGoogleClientID }
        
        guard GIDSignIn.sharedInstance.configuration != nil else {
            throw AuthError.noGoogleClientID
        }

        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    continuation.resume(throwing: AuthError.noGoogleToken)
                    return
                }

                let token = AuthToken(accessToken: idToken)
                self.repository.saveAuthToken(idToken, "google")
                continuation.resume(returning: token)
            }
        }
    }

    private func startSignInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension LoginUseCase: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = credential.identityToken,
            let tokenString = String(data: tokenData, encoding: .utf8)
        else {
            continuation?.resume(throwing: AuthError.noAppleToken)
            continuation = nil
            return
        }

        repository.saveAuthToken(tokenString, "apple")
        continuation?.resume(returning: AuthToken(accessToken: tokenString))
        continuation = nil
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

extension LoginUseCase: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first ?? UIWindow()
    }
}
