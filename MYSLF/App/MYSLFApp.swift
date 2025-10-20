//
//  MYSLFApp.swift
//  MYSLF
//
//  Created by Vitald3 on 17.10.2025.
//

import SwiftUI

@main
struct MYSLFApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var router = AppDI.shared.router
    
    var body: some Scene {
        WindowGroup {
            RootNavigationView()
                .environment(\.font, Font.custom("Urbanist", size: 16))
                .environmentObject(router)
        }
    }
}
