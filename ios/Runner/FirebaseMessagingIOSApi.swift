//
//  FirebaseMessagingIOSApi.swift
//  Runner
//
//  Created by 近松 和矢 on 2022/10/29.
//

import Foundation
import FirebaseMessaging

class FirebaseMessagingIOSApi: NSObject, FLTFirebaseMessagingApi {
    let appDelegate: AppDelegate
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func token() async -> (String?, FlutterError?) {
        do {
            return (try await Messaging.messaging().token(), nil)
        } catch let error {
            return (nil, FlutterError(code: "platform-error", message: "Failed to get token", details: error))
        }
    }
    
    func requestNotificationPermission() async -> (NSNumber?, FlutterError?) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let granted = try! await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        
        if (granted) {
            notificationCenter.delegate = self.appDelegate
        }
        
        return (granted as NSNumber, nil)
        
    }
    
    
}
