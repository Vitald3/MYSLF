//
//  AppDelegate.swift
//  MySecureX
//
//  Created by Vitald3 on 18.07.2025.
//

import UIKit
import GoogleSignIn
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: AppConstants.googleClientId
        )
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AppDI.shared.pushService.handleAPNSToken(deviceToken)
    }
}
