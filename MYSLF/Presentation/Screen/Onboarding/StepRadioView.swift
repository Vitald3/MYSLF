//
//  StepRadioView.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct StepRadioView: View {
    let title: String
    let content: [TextBloc]
    @Binding var checkedIndex: Int
    var helperText: String? = nil

    var body: some View {
        VStack(spacing: 28) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color("one-color"))
                .multilineTextAlignment(.center)

            if let helperText = helperText {
                InfoBubble(text: helperText)
            }

            VStack(spacing: 8) {
                ForEach(content.indices, id: \.self) { index in
                    HStack {
                        Radio(checked: Binding.constant(checkedIndex == index)) {
                            VStack(spacing: 2) {
                                HStack {
                                    Text(content[index].title)
                                        .font(.system(size: 20).weight(.bold))
                                        .foregroundColor(Color("one-color"))
                                    
                                    Spacer()
                                }
                                
                                if let text = content[index].text {
                                    HStack {
                                        Text(text)
                                            .foregroundColor(Color("second-color"))
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color("AppBox"))
                    .cornerRadius(16)
                    .shadow(color: Color(red: 0, green: 0, blue: 0.33, opacity: 0.04), radius: 14, y: 2)
                    .onTapGesture {
                        checkedIndex = index
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
