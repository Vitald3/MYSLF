//
//  Un+Focus+Tap.swift
//  NCKR
//
//  Created by Vitald3 on 02.08.2025.
//

import SwiftUI

struct HideKeyboardTap: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
    }
}

extension View {
    func hideKeyboardTap() -> some View {
        modifier(HideKeyboardTap())
    }
}
