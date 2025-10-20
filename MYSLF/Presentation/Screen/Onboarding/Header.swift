//
//  Header.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct Header: View {
    @Binding var step: Int
    let count: Int
    let title: String
    
    var body: some View {
        HStack {
            Button {
                step -= 1
            } label: {
                Image("back")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .overlay(
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16).weight(.semibold))
                    .foregroundColor(Color("one-color"))
                HStack(spacing: 4) {
                    ForEach(0..<count, id: \.self) { i in
                        Rectangle()
                            .frame(height: 4)
                            .cornerRadius(100)
                            .foregroundColor(step >= i ? Color("danger") : Color("second-color").opacity(0.1))
                    }
                }
            }
            .frame(width: 160)
        )
        .padding(.bottom, 12)
    }
}
