//
//  Camera.swift
//  MYSLF
//
//  Created by Vitald3 on 20.10.2025.
//

import SwiftUI
import AVFoundation
import UIKit

struct CameraView: View {
    @StateObject var viewModel: CameraViewModel
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()
                .onAppear {
                    Task {
                        await viewModel.configure()
                    }
                }
            
            ZStack {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 30))
                        .foregroundColor(Color("AppBox"))
                }
            }
            .offset(x: -20, y: 20)

            
            if viewModel.isCameraAccess {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.capturePhoto()
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                .shadow(radius: 5)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
