//
//  InfoBubble.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct InfoBubble: View {
    let text: String

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Image("jessica")
                .resizable()
                .frame(width: 40, height: 40)

            Text(text)
                .font(.system(size: 16).weight(.semibold))
                .foregroundColor(Color("one-color"))
                .padding(16)
                .background(Color("AppBox"))
                .cornerRadius(12)

            Spacer()
        }
    }
}
