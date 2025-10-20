//
//  SplashView.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import SwiftUI

struct SplashView: View {
    @StateObject var viewModel: SplashViewModel
    @EnvironmentObject var router: NavigationRouter
    
    @State private var isVisible: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "FCF9F8"), location: 0.0),
                    .init(color: Color(hex: "FFCDCD"), location: 0.31),
                    .init(color: Color(hex: "FFC3C3"), location: 0.43),
                    .init(color: Color(hex: "FAEAEA"), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: UnitPoint.init(x: 1.7, y: 0.5)
            )
            .ignoresSafeArea()
            
            if isVisible {
                Image("splash_logo")
                    .resizable()
                    .frame(width: 114, height: 114)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity).animation(.spring(duration: 0.6, bounce: 0.4)),
                        removal: .opacity.animation(.easeOut(duration: 0.3))
                    ))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    isVisible = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    if viewModel.tokenIsEmpty {
                        router.replace(.login)
                    } else {
                        router.replace(.welcome)
                    }
                }
            }
        }
    }
}
