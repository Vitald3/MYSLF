//
//  Checkbox.swift
//  NCKR
//
//  Created by Vitald3 on 27.08.2025.
//

import SwiftUI

struct Checkbox<Content: View>: View {
    @Binding var checked: Bool
    var content: () -> Content
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: {
                checked.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color("one-color"), lineWidth: 2)
                        .frame(width: 24, height: 24)
                        .background(
                            checked ? Color("one-color") : Color("AppBox")
                        )
                        .cornerRadius(4)
                    
                    if checked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("AppBox"))
                    }
                }
            }
            
            content()
            
            Spacer()
        }
    }
}
