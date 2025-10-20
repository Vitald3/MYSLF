//
//  Push.swift
//  MYSLF
//
//  Created by Vitald3 on 19.10.2025.
//

import SwiftUI

struct Push: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                (
                    Text("Stay on track with")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(Color("one-color"))
                    +
                    Text("gentle reminders")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(Color("second-color"))
                )
            }
            .multilineTextAlignment(.center)
            .padding(.top, 32)
            .padding(.bottom, 12)
            
            Text("I’ll send you motivational tips, workout reminders, and support — only when it matters")
                .foregroundColor(Color("one-color"))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Image("notify")
                .resizable()
                .scaledToFit()
            
            Spacer()
        }
        .padding(.bottom, 100)
        .padding(.horizontal, 28)
    }
}
