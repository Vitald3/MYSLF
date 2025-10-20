//
//  CoachCard.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct CoachCard: View {
    let coach: Coach

    var body: some View {
        VStack(spacing: 16) {
            Image(coach.image)
                .resizable()

            Text(coach.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color("one-color"))

            VStack(spacing: 8) {
                ForEach(coach.texts, id: \.self) { text in
                    HStack(spacing: 12) {
                        Image("star")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text(text)
                            .foregroundColor(Color("one-color"))
                        Spacer()
                    }
                }
            }
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 20, trailing: 16))
        .background(Color("AppBox"))
        .cornerRadius(24)
        .shadow(
          color: Color(red: 0.04, green: 0.09, blue: 0.39, opacity: 0.05), radius: 12, y: 2
        )
    }
}
