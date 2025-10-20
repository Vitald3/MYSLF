//
//  LoginButton.swift
//  MYSLF
//
//  Created by Vitald3 on 18.10.2025.
//

import SwiftUI

struct LoginButton: View {
    let icon: String
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(icon)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(text)
                    .font(.system(size: 15, weight: .medium))
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color("one-color"))
            .foregroundColor(Color("AppBox"))
            .cornerRadius(12)
        }
    }
}
