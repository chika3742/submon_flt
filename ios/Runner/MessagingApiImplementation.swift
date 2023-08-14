//
//  MessagingApiImplementation.swift
//  Runner
//
//  Created by Kazuya Chikamatsu on 2023/08/11.
//

import Flutter
import FirebaseMessaging

extension FlutterError: Error {}

class MessagingApiImplementation : MessagingApi {
    internal init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    let appDelegate: AppDelegate
    
    func isGoogleApiAvailable() throws -> Bool {
        throw FlutterError(code: "unsupported", message: "This method is not supported on this platform.", details: nil)
    }
    
    func getToken(completion: @escaping (Result<String?, Error>) -> Void) {
        Messaging.messaging().token(completion: { (token, error) in
            if error != nil {
                completion(.failure(FlutterError(code: "get-fcm-token-failed", message: "Failed to get FCM token.", details: error)))
            } else if let token = token {
                completion(.success(token))
            }
        })
    }
    
    func requestNotificationPermission(completion: @escaping (Result<NotificationPermissionStateWrapper?, Error>) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            if granted {
                notificationCenter.delegate = self.appDelegate
                completion(.success(NotificationPermissionStateWrapper(value: .granted)))
            } else {
                completion(.success(NotificationPermissionStateWrapper(value: .denied)))
            }
        }
    }
}
