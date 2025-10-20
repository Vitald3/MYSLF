//
//  GridType.swift.swift
//  MYSLF
//
//  Created by Vitald3 on 20.10.2025.
//

import SwiftUI

struct GridType: View {
    let zones: [String]
    let title: String
    @Binding var checked: Int
    var height: Double? = nil
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        VStack(spacing: 28) {
            Text(title)
                .font(.system(size: 24).weight(.bold))
                .foregroundColor(Color("one-color"))
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(zones.indices, id: \.self) { index in
                    VStack(spacing: 8) {
                        Image(zones[index].lowercased().replacingOccurrences(of: " ", with: "_"))
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: height ?? 116)
                        
                        HStack {
                            Text(zones[index])
                                .font(.system(size: 16).weight(.bold))
                                .foregroundColor(Color("one-color"))
                            
                            Spacer()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("second-color"), lineWidth: 1)
                                    .frame(width: 20, height: 20)
                                    .background(Color("AppBox"))
                                    .cornerRadius(20)
                                
                                if $checked.wrappedValue == index {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("one-color"), lineWidth: 1)
                                        .frame(width: 12, height: 12)
                                        .background(Color("one-color"))
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color("AppBox"))
                    .cornerRadius(16)
                    .onTapGesture {
                        checked = index
                    }
                }
            }
        }
        .padding(.horizontal, 28)
    }
}
