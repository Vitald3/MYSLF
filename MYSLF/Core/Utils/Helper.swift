//
//  Helper.swift
//  NCKR
//
//  Created by Vitald3 on 02.08.2025.
//

import UIKit

enum Helper {
    static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    static func pluralize(_ number: Int, one: String, few: String, many: String) -> String {
        let n = abs(number) % 100
        let lastDigit = n % 10
        
        if n > 10 && n < 20 {
            return many
        }
        if lastDigit == 1 {
            return one
        }
        if lastDigit >= 2 && lastDigit <= 4 {
            return few
        }
        return many
    }
    
    static func openURL(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    static var deviceID: String {
        if let existing = try? KeychainHelper.loadString(forKey: "\(AppConstants.bundleId).deviceID") {
            return existing
        } else {
            let newUUID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
            
            try? KeychainHelper
                .saveString(newUUID, forKey: "\(AppConstants.bundleId).deviceID")
            return newUUID
        }
    }
}
