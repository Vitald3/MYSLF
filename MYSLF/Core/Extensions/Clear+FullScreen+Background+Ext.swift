//
//  Full.swift
//  NCKR
//
//  Created by Vitald3 on 20.09.2025.
//

import SwiftUI

struct FullScreenBackgroundClearer: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}

extension View {
    func clearFullScreenBackground() -> some View {
        self.background(FullScreenBackgroundClearer())
    }
}
