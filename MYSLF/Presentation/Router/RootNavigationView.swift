//
//  RootNavigationView.swift
//  SecureX
//
//  Created by Vitald3 on 23.06.2025.
//

import SwiftUI

struct RootNavigationView: View {
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        ZStack(alignment: .topLeading) {
            if #available(iOS 16.0, *) {
                NavigationStack(path: $router.path) {
                    screenView(for: .splash)
                        .navigationDestination(for: Route.self) { route in
                            (route.view ?? AnyView(screenView(for: route.screen)))
                                .onSwipeBack {
                                    router.pop()
                                }
                                .navigationBarBackButtonHidden()
                        }
                }
                .onAppear {
                    if router.path.isEmpty {
                        router.path = [Route(screen: .splash)]
                    }
                }
            } else {
                NavigationView {
                    (router.path.last?.view ?? AnyView(screenView(for: .splash)))
                    .onSwipeBack {
                        router.pop()
                    }
                    .navigationBarBackButtonHidden()
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear {
                    if router.path.isEmpty {
                        router.path = [Route(screen: .splash)]
                    }
                }
            }
        }
        .sheet(item: $router.presentedSheet) { route in
            route.view ?? AnyView(sheetView(for: route.screen))
        }
        .fullScreenCover(item: $router.presentedFullScreen) { route in
            (route.view ?? AnyView(fullScreenView(for: route.screen)))
                .clearFullScreenBackground()
        }
        .customAlert(item: $router.presentedDialog)
    }
    
    @ViewBuilder
    private func screenView(for screen: Screen) -> some View {
        switch screen {
        case .splash:
            let viewModel: SplashViewModel = router.getOrCreateViewModel("splash") {
                SplashViewModel(
                    useCase: AppDI.shared.splashUseCase
                )
            }
            SplashView(viewModel: viewModel)
        case .login:
            let viewModel: LoginViewModel = router.getOrCreateViewModel("login") {
                LoginViewModel(
                    router: router,
                    useCase: AppDI.shared.loginUseCase
                )
            }
            LoginView(viewModel: viewModel)
        case .welcome:
            WelcomeView()
        case .personal:
            PersonalView()
        case .coach:
            CoachView(request: router.parameter(as: RegisterDeviceRequest.self))
        case .about:
            let viewModel: OnboardingViewModel = router.getOrCreateViewModel(
                "onboarding"
            ) {
                OnboardingViewModel(
                    router: router,
                    useCase: AppDI.shared.onboardingUseCase
                )
            }
            
            AboutView(viewModel: viewModel, request: router.parameter(as: RegisterDeviceRequest.self))
        case .camera:
            let viewModel: CameraViewModel = router.getOrCreateViewModel(
                "camera"
            ) {
                CameraViewModel(
                    router: router,
                    useCase: AppDI.shared.cameraUseCase
                )
            }
            
            CameraView(viewModel: viewModel)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func sheetView(for screen: Screen) -> some View {
        switch screen {
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    private func fullScreenView(for screen: Screen) -> some View {
        EmptyView()
    }
}
