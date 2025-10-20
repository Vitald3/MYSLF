//
//  WelcomeView.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var router: NavigationRouter
    
    @State private var agree = true

    var body: some View {
        ZStack {
            Image("welcome1")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer().frame(height: 32)
                
                VStack(spacing: 0) {
                    (
                        Text("Help your AI coach ")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(Color("one-color"))
                        +
                        Text("get")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(Color("second-color"))
                    )
                    (
                        Text("to know you")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(Color("second-color"))
                    )
                }
                .multilineTextAlignment(.center)

                Text("Your answers instantly shape your personalized schedule and help us support you better.")
                    .foregroundColor(Color("one-color"))
                    .multilineTextAlignment(.center)

                Image("welcome2")
                    .resizable()
                    .padding(.top, 4)
                    .padding(.bottom, 20)

                PrimaryButton(title: "Let’s Go!") {
                    router.replace(.personal)
                }

                Text("Privacy Policy")
                  .underline()
                  .foregroundColor(Color("one-color"))
                  .onTapGesture {
                      Helper.openURL(AppConstants.privacy)
                  }

                Spacer()
            }
            .padding(.horizontal, 22)
        }
        .ignoresSafeArea(.all, edges: [.bottom])
    }
}
