//
//  Validator.swift
//  NCKR
//
//  Created by Vitald3 on 02.08.2025.
//

import Foundation

enum Validator {
    static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    static func emailError(_ email: String) -> String? {
        isValidEmail(email) ? nil : "Введите корректный e-mail"
    }
    
    static func isValidPhone(_ phone: String) -> Bool {
        let digitsOnly = phone.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        let phoneRegex = "^(\\+7|8)[0-9]{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: digitsOnly)
    }
    
    static func isValidField(_ text: String) -> Bool {
        return !text.isEmpty
    }
    
    static func isValidSerial(_ text: String) -> Bool {
        !text.isEmpty && text.count == 4
    }
    
    static func serialError(_ text: String, _ error: String) -> String? {
        isValidSerial(text) ? nil : error
    }
    
    static func isValidNumber(_ text: String) -> Bool {
        !text.isEmpty && text.count == 6
    }
    
    static func numberError(_ text: String, _ error: String) -> String? {
        isValidSerial(text) ? nil : error
    }
    
    static func fieldError(_ text: String, _ error: String) -> String? {
        isValidField(text) ? nil : error
    }
    
    static func phoneError(_ phone: String) -> String? {
        isValidPhone(phone) ? nil : "Введите корректный номер телефона"
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
    
    static func isValidConfirm(_ confirm: String, _ password: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
        let isPasswordValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: confirm)
        return isPasswordValid && confirm == password
    }
    
    static func passwordError(_ password: String) -> String? {
        isValidPassword(password) ? nil : "Пароль должен содержать минимум 6 символов, включая буквы и цифры"
    }
    
    static func confirmError(_ password: String, _ confirm: String) -> String? {
        let valid = isValidPassword(password)
        
        if valid {
            return password == confirm ? nil : "Пароль не совпадают"
        } else {
            return "Пароль должен содержать минимум 6 символов, включая буквы и цифры"
        }
    }
    
    static func isValidCode(_ code: String) -> Bool {
        code.count == 6
    }
    
    static func codeError(_ code: String) -> String? {
        isValidCode(code) ? nil : "Код должен состоять из 6 цифр"
    }
}
