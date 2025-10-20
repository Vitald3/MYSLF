//
//  Radio.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct Radio<Content: View>: View {
    @Binding var checked: Bool
    var content: () -> Content
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: {
                checked.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("second-color"), lineWidth: 1)
                        .frame(width: 20, height: 20)
                        .background(Color("AppBox"))
                        .cornerRadius(20)
                    
                    if checked {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("one-color"), lineWidth: 1)
                            .frame(width: 12, height: 12)
                            .background(Color("one-color"))
                            .cornerRadius(12)
                    }
                }
            }
            
            content()
            
            Spacer()
        }
    }
}
