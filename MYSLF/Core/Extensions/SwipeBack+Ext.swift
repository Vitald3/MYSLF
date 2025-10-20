//
//  SwipeBack.swift
//  MySecureX
//
//  Created by Vitald3 on 16.07.2025.
//

import SwiftUI

extension View {
    func onSwipeBack(perform action: @escaping () -> Void) -> some View {
        self.overlay(
            GeometryReader { geometry in
                Color.clear
                    .frame(width: 20)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                if value.startLocation.x < 20 &&
                                    value.translation.width > 100 &&
                                    abs(value.translation.height) < 50 {
                                    action()
                                }
                            }
                    )
                    .allowsHitTesting(true)
                    .position(x: 20 / 2, y: geometry.size.height / 2)
            }
        )
    }
}
