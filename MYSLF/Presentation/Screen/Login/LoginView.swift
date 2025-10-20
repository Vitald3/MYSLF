//
//  WelcomeView.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var router: NavigationRouter
    
    @State private var agree = true

    var body: some View {
        ZStack {
            Image("welcome1")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer().frame(height: 32)

                VStack(spacing: 8) {
                    Text("Our AI gets smarter\nevery day — thanks to")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("one-color"))

                    Text("100,000+ users")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color("second-color"))
                }

                Text("Personalized workouts, meals, and recovery — designed to support your body and mind.")
                    .font(.system(size: 16))
                    .foregroundColor(Color("one-color"))
                    .multilineTextAlignment(.center)

                Image("onboarding1")
                    .resizable()
                    .padding(.top, 12)
                    .padding(.bottom, 20)

                Text("Your coach is ready — are you?")
                    .foregroundColor(Color("one-color"))

                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        LoginButton(icon: "google", text: "Google") {
                            viewModel.startGoogleLogin()
                        }

                        LoginButton(icon: "apple", text: "Apple") {
                            viewModel.startAppleLogin()
                        }
                    }

                    Text("OR")
                        .font(.caption)
                        .foregroundColor(Color("second-color"))

                    Button("Login Later") {
                        if !agree {
                            router
                                .showDialog(
                                    title: "Error",
                                    message: "Accept the terms of use",
                                    actions: [
                                        .init(title: "Ок", role: .destructive, action: nil)
                                    ]
                                )
                            
                            return
                        }
                        
                        router.replace(.welcome)
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("one-color"))
                    .frame(height: 52)
                    .frame(maxWidth: .infinity)
                    .background(Color("AppBox"))
                    .cornerRadius(16)
                    .shadow(
                      color: Color(red: 0, green: 0.05, blue: 0.35, opacity: 0.08), radius: 16, y: 2
                    )
                }

                Spacer()

                Checkbox(checked: $agree) {
                    Text(makeAttributedString())
                        .multilineTextAlignment(.leading)
                }
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 28)
        }
        .ignoresSafeArea(.all, edges: [.bottom])
    }
    
    private func makeAttributedString() -> AttributedString {
        var str = AttributedString("By continuing, you agree to our Privacy Policy and Terms")

        if let range = str.range(of: String(str.characters)) {
            str[range].foregroundColor = .init(Color("one-color"))
        }

        if let range = str.range(of: "Privacy Policy") {
            str[range].link = URL(string: AppConstants.privacy)
            str[range].underlineStyle = .single
            str[range].foregroundColor = .init(Color("danger"))
        }

        if let range = str.range(of: "Terms") {
            str[range].link = URL(string: AppConstants.terms)
            str[range].underlineStyle = .single
            str[range].foregroundColor = .init(Color("danger"))
        }

        return str
    }
}
