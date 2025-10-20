//
//  Sex.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct Sex: View {
    @Binding var gender: String
    let sex: String
    let image: String
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topLeading) {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(gender == sex ?
                              sex == "Female" ? Color("jes") : Color(hex: "E3F4FF")
                              : Color("AppBox"))
                        .frame(height: 174)
                        .cornerRadius(20)
                        .shadow(
                            color: Color(red: 0, green: 0, blue: 0.33, opacity: 0.04), radius: 14, y: 2
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .inset(by: 0.75)
                                .stroke(gender == sex ? Color("one-color") : .clear, lineWidth: 0.75)
                        )
                    
                    Image(image)
                        .resizable()
                        .frame(width: 113, height: 202)
                }
                
                ZStack() {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 14, height: 14)
                        .background(
                            gender == sex ? Color(
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
                        .stroke(Color(gender == sex ? "one-color" : "second-color"), lineWidth: 0.50)
                )
                .frame(width: 24, height: 24)
                .offset(x: 16, y: 42)
            }
            
            Text(sex)
                .font(.system(size: 16).weight(.semibold))
                .foregroundColor(Color("one-color"))
        }
        .onTapGesture {
            gender = sex
        }
    }
}
