//
//  PushService.swift
//  MySecureX
//
//  Created by Vitald3 on 18.07.2025.
//

import UserNotifications
import FirebaseMessaging
import UIKit

protocol PushServiceDelegate: AnyObject {
    func didReceiveFCMToken(_ token: String)
}

protocol PushService {
    var delegate: PushServiceDelegate? { get set }
    
    func configure(completion: ((Bool) -> Void)?)
    func handleAPNSToken(_ deviceToken: Data)
}

final class DefaultPushService: NSObject, PushService {
    weak var delegate: PushServiceDelegate?

    func configure(completion: ((Bool) -> Void)? = nil) {
#if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            completion?(false)
            return
        }
#endif
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        requestAuthorization(completion: completion)
    }

    func handleAPNSToken(_ deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        fetchFCMToken()
    }
    
    private func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                completion?(granted)
            }
        }
    }

    private func fetchFCMToken() {
        Messaging.messaging().token { [weak self] token, error in
            guard let self, let token else { return }
            self.delegate?.didReceiveFCMToken(token)
        }
    }
}

extension DefaultPushService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        delegate?.didReceiveFCMToken(token)
    }
}

extension DefaultPushService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .list, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
}
