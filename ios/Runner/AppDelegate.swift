import UIKit
import Flutter
import AuthenticationServices
import SafariServices
import Firebase
import FirebaseMessaging
import FirebaseAuth
import FirebaseAppCheck
import WidgetKit

@available(iOS 13.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var viewController: FlutterViewController?
    var uriEvent: UriEventChannelHandler?
    var mainMethodCallHandler: MainMethodChannelHandler?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        #if !RELEASE
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        #endif
        
        FirebaseApp.configure()
        
        do {
            try Auth.auth().useUserAccessGroup("B66Z929S96.net.chikach.submon")
        } catch let error as NSError {
            print(error)
        }
        
        viewController = window?.rootViewController as? FlutterViewController
        
        mainMethodCallHandler = MainMethodChannelHandler(viewController: viewController!)
        mainMethodCallHandler?.register()
        MessagingMethodChannelHandler(viewController: viewController!, appDelegate: self).register()
        
        uriEvent = UriEventChannelHandler(binaryMessenger: viewController!.binaryMessenger)
        
        initNotificationCategories()
        
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (uriEvent != nil && uriEvent?.eventSink != nil) {
            uriEvent?.eventSink?(url.absoluteString)
        } else {
            mainMethodCallHandler?.pendingUri = url.absoluteString
        }
        
        return true
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        switch response.notification.request.content.categoryIdentifier {
        case "reminder":
            if response.actionIdentifier == "openCreateSubmission" {
                openUrl(path: "/create-submission")
            }
            break;
            
        case "digestive":
            if response.actionIdentifier == "openFocusTimer" {
                openUrl(path: "/focus-timer?digestiveId=\(userInfo["digestiveId"] ?? "-1")")
            } else {
                if (userInfo["submissionId"] as? String? != "-1") {
                    openUrl(path: "/submission?id=\(userInfo["submissionId"] ?? "-1")")
                } else {
                    openUrl(path: "/tab/digestive")
                }
            }
            
        case "timetable":
            openUrl(path: "/tab/timetable")
            
        default: break
        }
        completionHandler()
    }
    
    private func openUrl(path: String) {
        UIApplication.shared.open(URL(string: "submon://\(path)")!, options: [:], completionHandler: nil)
    }
    
    func initNotificationCategories() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.setNotificationCategories([
            UNNotificationCategory(identifier: "reminder", actions: [
                UNNotificationAction(identifier: "openCreateSubmission", title: "新規作成", options: [.foreground])
            ], intentIdentifiers: [], options: []),
            UNNotificationCategory(identifier: "timetable", actions: [], intentIdentifiers: [], options: []),
            UNNotificationCategory(identifier: "digestive", actions: [
                UNNotificationAction(identifier: "openFocusTimer", title: "集中タイマー", options: [.foreground]),
            ], intentIdentifiers: [], options: [])
        ])
        
        notificationCenter.getNotificationSettings(completionHandler: { (settings) in
            if (settings.authorizationStatus == .authorized) {
                notificationCenter.delegate = self
            }
        })
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: ["token": fcmToken ?? ""])
        
        if (fcmToken != nil) {
            mainMethodCallHandler?.saveMessagingToken(token: fcmToken!)
        }
    }
}
