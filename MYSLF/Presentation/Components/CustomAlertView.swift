//
//  CustomAlertView.swift
//  NCKR
//
//  Created by Vitald3 on 27.08.2025.
//

import SwiftUI

struct CustomAlertAction {
    let title: String
    let style: AlertStyle
    let action: (() -> Void)?
    
    enum AlertStyle {
        case normal
        case cancel
        case destructive
    }
}

struct CustomAlertView: View {
    let title: String
    let message: String
    let actions: [CustomAlertAction]
    
    var body: some View {
        let width = UIScreen.main.bounds.width
        
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 18).weight(.medium))
                    .foregroundColor(Color("one-color"))
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            HStack {
                Text(message)
                    .font(.system(size: 13))
                    .lineLimit(4)
                    .foregroundColor(Color("one-color"))
                
                Spacer()
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                ForEach(0..<actions.count, id: \.self) { index in
                    let item = actions[index]
                    
                    PrimaryButton(title: item.title, style: PrimaryButtonStyle(from: item.style), action: {
                        item.action?()
                    })
                }
            }
        }
        .frame(
            width: (
                width > 335 ? 335 : width
            ) - AppConstants.padding * 2
        )
        .padding(.horizontal, AppConstants.padding)
        .padding(.vertical, 25)
        .background(Color("AppBox"))
        .cornerRadius(16)
        .shadow(color: Color("one-color").opacity(0.2), radius: 12, x: 0, y: 4)
    }
    
    private func background(for style: CustomAlertAction.AlertStyle) -> LinearGradient {
        switch style {
        case .normal:
            return LinearGradient(colors: [Color.blue, Color.blue.opacity(0.8)],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .cancel:
            return LinearGradient(colors: [Color.gray.opacity(0.8), Color.gray],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .destructive:
            return LinearGradient(colors: [Color.red, Color.red.opacity(0.8)],
                                  startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

struct CustomDialogAction: Identifiable {
    let id = UUID()
    let title: String
    let role: ButtonRole?
    let action: (() -> Void)?
}

struct CustomDialog: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let actions: [CustomDialogAction]
}

struct CustomAlertModifier: ViewModifier {
    @Binding var item: CustomDialog?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let dialog = item {
                Color("one-color").opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { item = nil }
                
                CustomAlertView(
                    title: dialog.title,
                    message: dialog.message,
                    actions: dialog.actions.map { act in
                        CustomAlertAction(
                            title: act.title,
                            style: mapRoleToStyle(act.role),
                            action: {
                                act.action?()
                                item = nil
                            }
                        )
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .animation(.easeInOut, value: item != nil)
    }
    
    private func mapRoleToStyle(_ role: ButtonRole?) -> CustomAlertAction.AlertStyle {
        switch role {
        case .cancel: return .cancel
        case .destructive: return .destructive
        default: return .normal
        }
    }
}

extension View {
    func customAlert(item: Binding<CustomDialog?>) -> some View {
        self.modifier(CustomAlertModifier(item: item))
    }
}
