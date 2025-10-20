//
//  PersonalView.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

import SwiftUI

struct PersonalView: View {
    @EnvironmentObject var router: NavigationRouter
    
    @State private var step = 0
    @State private var name = ""
    @State private var age = 20
    @State private var gender = "Female"
    @FocusState private var focusedField: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("welcome1")
                .resizable()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack {
                Header(step: $step, count: 3, title: "About you")
                
                VStack {
                    switch step {
                    case 0:
                        VStack {
                            VStack(spacing: 8) {
                                Text("Tell me your name — ")
                                    .font(.system(size: 24, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("one-color"))
                                
                                Text("I’d love to know")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color("second-color"))
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 12) {
                                TextField("", text: $name)
                                    .multilineTextAlignment(.center)
                                    .frame(minWidth: 160)
                                    .focused($focusedField)
                                    .submitLabel(.done)
                                    .font(.system(size: 52).weight(.bold))
                                    .foregroundColor(Color("one-color"))
                                    .onSubmit {
                                        if !name.isEmpty {
                                            withAnimation {
                                                step = 1
                                            }
                                        }
                                    }
                                
                                Rectangle()
                                  .foregroundColor(.clear)
                                  .frame(height: 0.50)
                                  .overlay(
                                    Rectangle()
                                      .stroke(Color(red: 0.86, green: 0.86, blue: 0.86), lineWidth: 0.50)
                                  )
                            }
                            .frame(minWidth: 160)
                            
                            Spacer()
                        }
                        .keyboardAdaptive()
                        .hideKeyboardTap()
                        .onAppear {
                            focusedField = true
                        }
                    case 1:
                        VStack(spacing: 0) {
                            Text("What’s your age?")
                                .font(.system(size: 30).weight(.heavy))
                                .foregroundColor(Color("one-color"))
                                .padding(.bottom, 28)
                            
                            HStack(alignment: .bottom, spacing: 8) {
                                Image("jessica")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading) {
                                  Text("This helps me choose the safest load and right calorie balance for you 💪")
                                        .font(
                                            .system(size: 16).weight(.semibold)
                                        )
                                        .foregroundColor(Color(red: 0.13, green: 0.12, blue: 0.16))
                                }
                                .padding(16)
                                .background(Color("AppBox"))
                                .cornerRadius(12)
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Picker(selection: $age, label: Text("")) {
                                    ForEach(8...80, id: \.self) { age in
                                        Text("\(age)")
                                            .font(.system(size: 40, weight: .semibold))
                                            .minimumScaleFactor(0.8)
                                            .foregroundColor(Color("one-color"))
                                            .tag(age)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 283)
                                .clipped()

                                Text("years old")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("second-color"))
                            }
                            .frame(height: 283)
                            
                            Spacer()
                            
                            Text("We never share your personal data with anyone")
                                .font(.system(size: 14).weight(.semibold))
                                .foregroundColor(Color("second-color"))
                                .padding(.bottom, 12)
                        }
                    case 2:
                        VStack(spacing: 0) {
                            Text("What’s your gender?")
                                .font(.system(size: 30).weight(.heavy))
                                .foregroundColor(Color("one-color"))
                                .padding(.bottom, 28)
                            
                            HStack(alignment: .bottom, spacing: 8) {
                                Image("jessica")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading) {
                                  Text("Knowing this helps me choose the safest workouts and most balanced nutrition for you.")
                                        .font(
                                            .system(size: 16).weight(.semibold)
                                        )
                                        .foregroundColor(Color(red: 0.13, green: 0.12, blue: 0.16))
                                }
                                .padding(16)
                                .background(Color("AppBox"))
                                .cornerRadius(12)
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    Sex(gender: $gender, sex: "Male", image: "Max")
                                    Sex(gender: $gender, sex: "Female", image: "Jes")
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack(spacing: 20) {
                                        ZStack() {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 14, height: 14)
                                                .background(
                                                    gender == "Prefer Not to Say" ? Color(
                                                        "one-color"
                                                    ) : .clear
                                                )
                                                .cornerRadius(100)
                                                .offset(x: 0, y: 0)
                                        }
                                        .frame(width: 24, height: 24)
                                        .cornerRadius(100)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 100)
                                                .inset(by: 0.50)
                                                .stroke(Color(gender == "Prefer Not to Say" ? "one-color" : "second-color"), lineWidth: 0.50)
                                        )
                                        
                                        Text("Prefer Not to Say")
                                            .font(
                                                .system(size: 16)
                                                .weight(.semibold)
                                            )
                                            .foregroundColor(Color("one-color"))
                                        
                                        Spacer()
                                    }
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(Color("AppBox"))
                                .cornerRadius(16)
                                .shadow(
                                    color: Color(red: 0, green: 0, blue: 0.33, opacity: 0.04), radius: 14, y: 2
                                )
                                .onTapGesture {
                                    gender = "Prefer Not to Say"
                                }
                            }
                            
                            Spacer()
                        }
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 28)
                .padding(.top, 12)
                .padding(.bottom, 80 + UIApplication.shared.safeAreaInsets.bottom)
            }
            
            VStack {
                Spacer()
                
                VStack {
                    PrimaryButton(title: step == 0 ? "Continue" : "Next") {
                        if step == 2 {
                            router.push(.coach, with: RegisterDeviceRequest(
                                uuid: Helper.deviceID,
                                name: name,
                                age: age,
                                sex: gender
                            ))
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
}
