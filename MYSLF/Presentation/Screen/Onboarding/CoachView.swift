//
//  CoachView.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct CoachView: View {
    @EnvironmentObject var router: NavigationRouter
    
    @State private var step = 0
    @State private var selection = 0
    let request: RegisterDeviceRequest?
    
    private let coaches = [
        Coach(name: "Mia", image: "Mia", texts: [
            "Caring",
            "I'll help you build lifelong habits",
            "I use gentle motivation instead of \"Come on, one more!\"",
        ]),
        Coach(name: "Luna", image: "Luna", texts: [
            "Focused and results-driven",
            "I’ll keep everything in check: calories, steps, heart rate — no excuses",
            "I’ll raise the bar every week",
        ]),
        Coach(name: "Max", image: "Max2", texts: [
            "Motivation without the noise",
            "Form first, kilos second",
            "Keeps muscles working, joints safe",
        ])
    ]
    
    init(request: RegisterDeviceRequest? = nil) {
        self.request = request
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("welcome1")
                .resizable()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack {
                Header(step: $step, count: 3, title: "Coaches")
                
                VStack {
                    switch step {
                    case 0:
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                (
                                    Text("Each coach has their own vibe — ")
                                        .font(.system(size: 30, weight: .heavy))
                                        .foregroundColor(Color("one-color"))
                                    +
                                    Text("who’s yours?")
                                        .font(.system(size: 30, weight: .heavy))
                                        .foregroundColor(Color("second-color"))
                                )
                            }
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 12)
                            
                            Text("Three pro coaches—each motivates and communicates in their own way.")
                              .foregroundColor(Color("one-color"))
                              .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            Image("coaches")
                                .resizable()
                                .padding(.vertical, 40)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 28)
                    case 1:
                        VStack(spacing: 0) {
                            Text("Meet your coach")
                                .font(.system(size: 30).weight(.heavy))
                                .foregroundColor(Color("one-color"))
                                .padding(.bottom, 28)
                            
                            Spacer()
                            
                            StablePageView(selection: $selection, count: coaches.count) {
                                ForEach(Array(coaches.enumerated()), id: \.offset) { index, coach in
                                    CoachCard(coach: coach)
                                        .padding(.horizontal, 28)
                                        .tag(index)
                                }
                            }
                            .padding(.bottom, 24)
                            
                            HStack(spacing: 8) {
                                ForEach(
                                    0..<coaches.count,
                                    id: \.self
                                ) { index in
                                    Ellipse()
                                      .foregroundColor(.clear)
                                      .frame(width: 12, height: 12)
                                      .background(selection >= index ? Color("one-color") : .clear)
                                      .overlay(
                                        Ellipse()
                                          .inset(by: 0.50)
                                          .stroke(Color("one-color"), lineWidth: 0.50)
                                      )
                                      .cornerRadius(12)
                                }
                            }
                            .padding(.bottom, 20)
                            
                            Spacer()
                        }
                    case 2:
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                (
                                    Text("Congrats! ")
                                        .font(.system(size: 30, weight: .heavy))
                                        .foregroundColor(Color("one-color"))
                                    +
                                    Text("I’m your new coach, \(selection == 0 ? "Mia" : selection == 1 ? "Luna" :"Max")!")
                                        .font(.system(size: 30, weight: .heavy))
                                        .foregroundColor(Color("second-color"))
                                )
                            }
                            .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            ZStack(alignment: .bottomLeading) {
                                Image(selection == 0 ? "Mia" : selection == 1 ? "Luna" :"Max2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                
                                Text("Let’s set your\ngoals together")
                                    .font(
                                        .system(size: 20)
                                        .weight(.semibold)
                                    )
                                    .foregroundColor(Color("one-color"))
                                    .padding(12)
                                    .background(Color("AppBox"))
                                    .cornerRadius(12)
                                    .shadow(
                                        color: Color(red: 0.04, green: 0.09, blue: 0.39, opacity: 0.05), radius: 12, y: 2
                                    )
                                    .offset(x: 20, y: -20)
                            }
                            .padding(.vertical, 23)
                            .padding(.horizontal, 28)

                            Spacer()
                        }
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 80 + UIApplication.shared.safeAreaInsets.bottom)
            }
            
            VStack {
                Spacer()
                
                VStack {
                    PrimaryButton(title: buttonText) {
                        if step == 2 {
                            let updated = request?.copyWith(
                                coach: coach
                            )
                            router.push(.about, with: updated)
                            return
                        }
                        
                        step = step + 1
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 28, bottom: 12 + UIApplication.shared.safeAreaInsets.bottom, trailing: 28))
                .background(Color("AppBox"))
                .cornerRadius(
                    16,
                    corners: [.topLeft, .topRight]
                )
                .shadow(
                  color: Color(red: 0, green: 0, blue: 0, opacity: 0.06), radius: 28
                )
            }
        }
        .ignoresSafeArea(.all, edges: [.bottom])
    }
    
    private var buttonText: String {
        switch step {
        case 0:
            return "Choose your coach"
        case 1:
            return coach
        case 2:
            return "Let’s Go"
        default:
            return "Next"
        }
    }
    
    private var coach: String {
        switch selection {
        case 1:
            return "Train with Luna"
        case 2:
            return "Train with Max"
        default:
            return "Train with Mia"
        }
    }
}
