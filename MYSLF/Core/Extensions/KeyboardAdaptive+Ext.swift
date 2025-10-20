//
//  KeyboardAdaptive.swift
//  NCKR
//
//  Created by Vitald3 on 03.10.2025.
//

import SwiftUI
import Combine

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    @State private var cancellable: AnyCancellable?

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, max(0, keyboardHeight - geometry.safeAreaInsets.bottom))
                .animation(.easeOut(duration: 0.25), value: keyboardHeight)
                .onAppear {
                    cancellable = Publishers.keyboardHeight
                        .receive(on: RunLoop.main)
                        .assign(to: \.keyboardHeight, on: self)
                }
                .onDisappear {
                    cancellable?.cancel()
                }
        }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        self.modifier(KeyboardAdaptive())
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification -> CGFloat? in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height
            }
            .eraseToAnyPublisher()

        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .eraseToAnyPublisher()

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

