//
//  CustomInput.swift
//  MySecureX
//
//  Created by Vitald3 on 17.07.2025.
//

import SwiftUI
import Combine

struct CustomInput: View {
    @EnvironmentObject var router: NavigationRouter
    @StateObject private var fieldRef: CustomTextFieldReference
    let fieldKey: String
    var order: Int? = nil
    var label: String
    var hint: String? = nil
    @Binding var text: String
    var isSecure: Bool? = false
    var isDisable: Bool? = false
    var trailingIcon: String? = nil
    var iconActive: Bool = false
    var onTrailingTap: (() -> Void)? = nil
    var validation: ((String) -> Bool)? = nil
    var onChange: ((String) -> Void)? = nil
    var errorMessage: String? = nil
    var type: SubmitLabel? = nil
    var keyboardType: UIKeyboardType? = .default

    @State private var displayedText: String = ""

    @FocusState private var isFocused: Bool
    @State private var showPassword: Bool = false
    @State private var isValidationError: Bool = false
    @State private var isValid: Bool = false
    @State private var didSetup = false

    init(
        fieldKey: String,
        order: Int? = nil,
        label: String,
        hint: String? = nil,
        text: Binding<String>,
        isSecure: Bool? = false,
        isDisable: Bool? = false,
        trailingIcon: String? = nil,
        iconActive: Bool = false,
        onTrailingTap: (() -> Void)? = nil,
        validation: ((String) -> Bool)? = nil,
        onChange: ((String) -> Void)? = nil,
        errorMessage: String? = nil,
        type: SubmitLabel? = nil,
        keyboardType: UIKeyboardType? = .default
    ) {
        self.fieldKey = fieldKey
        self.order = order ?? -1
        self.label = label
        self.hint = hint
        self._text = text
        self.isSecure = isSecure
        self.isDisable = isDisable
        self.trailingIcon = trailingIcon
        self.iconActive = iconActive
        self.onTrailingTap = onTrailingTap
        self.validation = validation
        self.onChange = onChange
        self.errorMessage = errorMessage
        self.type = type
        self.keyboardType = keyboardType

        _fieldRef = StateObject(wrappedValue: CustomTextFieldReference(screenId: "", fieldKey: fieldKey, order: order ?? -1))
    }

    var body: some View {
        let inputField: AnyView = {
            if (isSecure ?? false) {
                return AnyView(
                    TextField("", text: $displayedText)
                        .onChange(of: displayedText) { newValue in
                            if newValue.count > text.count {
                                let newChar = newValue.suffix(1)
                                text.append(contentsOf: newChar)
                            } else if newValue.count < text.count {
                                text = String(text.prefix(newValue.count))
                            }

                            if !showPassword {
                                displayedText = String(repeating: "•", count: text.count)
                            }

                            onChange?(newValue)

                            if isValidationError {
                                handleSubmit()
                            }
                        }
                        .onChange(of: isFocused) { focused in
                            if !focused && !showPassword {
                                displayedText = String(repeating: "•", count: text.count)
                            }
                        }
                        .onChange(of: showPassword) { value in
                            if !value {
                                displayedText = String(repeating: "•", count: text.count)
                            } else {
                                displayedText = text
                            }
                        }
                        .textContentType(.password)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(keyboardType ?? .default)
                        .focused($isFocused)
                        .submitLabel(type ?? .done)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color(isValidationError ? "danger" : "one-color"))
                        .font(.system(size: 16))
                        .frame(height: 54)
                        .onChange(of: text) { value in
                            if !showPassword {
                                displayedText = String(repeating: "•", count: value.count)
                            }

                            onChange?(value)

                            if isValidationError {
                                handleSubmit()
                            }
                        }
                        .onSubmit {
                            handleSubmit()
                            onChange?(text)
                        }
                        .onAppear {
                            displayedText = String(repeating: "•", count: text.count)
                        }
                        .disabled(isDisable!)
                )
            } else {
                return AnyView(
                    TextField("", text: $text, prompt: Text(hint ?? label).foregroundColor(Color(isValidationError ? "danger" : "hint")))
                        .keyboardType(keyboardType ?? .default)
                        .focused($isFocused)
                        .submitLabel(type ?? .done)
                        .onSubmit {
                            handleSubmit()
                            onChange?(text)
                        }
                        .onChange(of: text) { value in
                            onChange?(value)
                        }
                        .padding(.vertical, 13)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color(isValidationError ? "danger" : "one-color"))
                        .font(.system(size: 16))
                        .frame(height: 54)
                        .disabled(isDisable!)
                )
            }
        }()

        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .foregroundColor(Color("hint"))

            ZStack(alignment: .trailing) {
                inputField

                HStack(spacing: 0) {
                    if (isSecure ?? false) {
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .frame(width: 18, height: 13)
                                .foregroundColor(isValidationError ? Color("danger") : Color("one-color"))
                        }
                        .padding(.trailing, 20)
                    } else if let trailingIcon = trailingIcon {
                        Button(action: {
                            onTrailingTap?()
                        }) {
                            Image(systemName: trailingIcon)
                                .foregroundColor(iconActive ? Color("link") : Color("one-color"))
                        }
                        .padding(.trailing, 20)
                    }
                }
            }
            .background(
                Color(isValid ? "AppBox" : isValidationError ? "input-danger" : "input-background")
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(isValid ? "hint" : isValidationError ? "danger" : (isFocused ? "link" : "input-background")), lineWidth: 1)
            )
            .onTapGesture {
                isFocused = true
            }
            .cornerRadius(10)

            if isValidationError, let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .foregroundColor(Color("danger"))
                    .padding(.leading, 4)
            }
        }
        .onReceive(fieldRef.$isValid) { value in
            isValidationError = !value
            isValid = value && !text.isEmpty
        }
        .task(id: fieldRef.id) {
            guard !didSetup else { return }
            didSetup = true
            
            fieldRef.screenId = router.path.last?.screen.id ?? Screen.splash.id
            fieldRef.isVisible = true
            fieldRef.validation = validation
            fieldRef.valueProvider = { text }
            isValid = fieldRef.isValid && !text.isEmpty
            fieldRef.focusBinding = $isFocused
            CustomTextFieldCoordinator.shared.register(reference: fieldRef)
        }
        .onDisappear {
            CustomTextFieldCoordinator.shared.unregister(reference: fieldRef)
        }
    }

    private func handleSubmit() {
        fieldRef.validate()
        isValidationError = !fieldRef.isValid
        CustomTextFieldCoordinator.shared.focusNext(after: fieldRef)
    }
}

final class CustomTextFieldCoordinator {
    static let shared = CustomTextFieldCoordinator()

    private init() {}

    private var fieldsByScreen: [String: [CustomTextFieldReference]] = [:]
    private var currentScreenId: String?

    func setCurrentScreen(_ screenId: String?) {
        currentScreenId = screenId
    }

    func register(reference: CustomTextFieldReference) {
        fieldsByScreen[reference.screenId, default: []].removeAll { $0.id == reference.id }
        fieldsByScreen[reference.screenId, default: []].append(reference)
    }

    func unregister(reference: CustomTextFieldReference) {
        fieldsByScreen[reference.screenId]?.removeAll { $0.id == reference.id }
    }

    func clearScreen(_ screenId: String) {
        fieldsByScreen.removeValue(forKey: screenId)
    }

    func clearAll() {
        fieldsByScreen.removeAll()
    }

    func validateAllFields() -> Bool {
        guard let screenId = currentScreenId,
              let fields = fieldsByScreen[screenId] else { return true }

        var allValid = true
        for ref in fields where ref.isVisible {
            ref.validate()
            if !ref.isValid { allValid = false }
        }
        return allValid
    }

    func focusNext(after current: CustomTextFieldReference) {
        guard let fields = fieldsByScreen[current.screenId] else { return }

        let sorted = fields.sorted { $0.order < $1.order }
        guard let index = sorted.firstIndex(where: { $0.id == current.id }) else { return }
        
        let nextIndex = index + 1
        if nextIndex < sorted.count {
            let next = sorted[nextIndex]
            current.focusBinding?.wrappedValue = false
            next.focusBinding?.wrappedValue = true
        } else {
            current.focusBinding?.wrappedValue = false
        }
    }
}


final class CustomTextFieldReference: ObservableObject, Identifiable {
    let id = UUID()
    let order: Int
    var screenId: String
    @Published var isValid: Bool = true
    @Published var isVisible: Bool = false
    var validation: ((String) -> Bool)?
    var valueProvider: (() -> String)?
    var focusBinding: FocusState<Bool>.Binding?

    init(screenId: String, fieldKey: String, order: Int) {
        self.screenId = "\(screenId)_\(fieldKey)"
        self.order = order
    }

    func validate() {
        if !isVisible {
            isValid = true
            return
        }
        if let validation, let value = valueProvider?() {
            isValid = validation(value)
        } else {
            isValid = false
        }
    }
}
