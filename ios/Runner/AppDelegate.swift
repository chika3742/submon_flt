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
@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var viewController: FlutterViewController?
    
    var uriEventApi: UriEventApi?
    var fcmTokenRefreshEventApi: FcmTokenRefreshEventApi?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        #if RELEASE
        AppCheck.setAppCheckProviderFactory(MyAppCheckProviderFactory())
        #else
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        #endif
        
        FirebaseApp.configure()
        
        do {
            try Auth.auth().useUserAccessGroup("B66Z929S96.net.chikach.submon")
        } catch let error as NSError {
            print(error)
        }
        
        initNotificationCategories()
        
        viewController = window?.rootViewController as? FlutterViewController
        let binaryMessenger = viewController!.binaryMessenger
        
        // Event Channels
        uriEventApi = UriEventApi(binaryMessenger: binaryMessenger)
        uriEventApi!.initHandler()
        fcmTokenRefreshEventApi = FcmTokenRefreshEventApi(binaryMessenger: binaryMessenger)
        fcmTokenRefreshEventApi!.initHandler()
        
        // Pigeon APIs
        MessagingApiSetup.setUp(binaryMessenger: binaryMessenger, api: MessagingApiImplementation(appDelegate: self))
        BrowserApiSetup.setUp(binaryMessenger: binaryMessenger, api: BrowserApiImplementation(viewController: viewController!))
        GeneralApiSetup.setUp(binaryMessenger: binaryMessenger, api: GeneralApiImplementation())
        
        // Firebase Cloud Messaging
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        uriEventApi?.onUri(uri: url.absoluteString)

        return true
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingUrl = userActivity.webpageURL else {
            return false
        }
        uriEventApi?.onUri(uri: incomingUrl.absoluteString)
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
            fcmTokenRefreshEventApi?.onFcmTokenRefresh(token: fcmToken!)
        }
    }
}

extension AppDelegate {
    func handleShortcutItem(_ item: UIApplicationShortcutItem) -> Bool {
        switch item.type {
        case "CreateSubmissionAction":
            openUrl(path: "/create-submission")
            break
            
        case "DigestiveTabAction":
            openUrl(path: "/tab/digestive")
            break
            
        case "TimetableTabAction":
            openUrl(path: "/tab/timetable")
            break
            
        default: return false
        }
        
        return true
    }
    
    override func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(shortcutItem))
    }
}
