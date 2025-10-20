//
//  PrimaryButton.swift
//  NCKR
//
//  Created by Vitald3 on 31.07.2025.
//

import SwiftUI

extension PrimaryButtonStyle {
    init(from alertStyle: CustomAlertAction.AlertStyle) {
        switch alertStyle {
        case .normal:
            self = .primary
        case .cancel:
            self = .secondary
        case .destructive:
            self = .destructive
        }
    }
}

enum PrimaryButtonStyle {
    case primary
    case secondary
    case destructive
    
    var background: AnyShapeStyle {
        switch self {
        case .primary:
            return AnyShapeStyle(Color("one-color"))
        case .secondary:
            return AnyShapeStyle(Color("second-color").opacity(0.3))
        case .destructive:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color.red, Color("danger").opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
    
    var textColor: Color {
        switch self {
        case .secondary: return Color("one-color")
        default: return Color("AppBox")
        }
    }
}

struct PrimaryButton: View {
    let title: String
    var style: PrimaryButtonStyle = .primary
    var height: CGFloat = 52
    var cornerRadius: CGFloat = 16
    var background: Color? = nil
    var borderColor: Color? = nil
    var textColor: Color? = nil
    var borderWidth: CGFloat = 1
    var isEnabled: Bool = true
    var loading: Bool = true
    let action: () async -> Void
    
    @State private var isLoadingState: Bool = false
    
    private var isLoading: Bool {
        loading || isLoadingState
    }
    
    var body: some View {
        let back = background != nil ? AnyShapeStyle(background!) : nil
        
        Button(action: {
            guard !isLoading else { return }
            Task {
                isLoadingState = true
                await action()
                isLoadingState = false
            }
        }) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.textColor))
                        .scaleEffect(1.2)
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(textColor ?? style.textColor)
                        .frame(maxWidth: .infinity, minHeight: height)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: height)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(back ?? style.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor ?? .clear, lineWidth: borderColor == nil ? 0 : borderWidth)
        )
        .disabled(!isEnabled || isLoading)
        .opacity(isEnabled ? 1 : 0.6)
    }
}
