import UIKit
import Flutter
import AuthenticationServices
import SafariServices
import Firebase
import FirebaseMessaging
import FirebaseAuth
import FirebaseFirestore
import WidgetKit

let notifChannel = "submon/notification"
let actionsChannel = "submon/actions"

@available(iOS 13.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var viewController: FlutterViewController?
    var actionMethodChannelHandler: ActionMethodChannelHandler?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        do {
            try Auth.auth().useUserAccessGroup("B66Z929S96.net.chikach.submon")
        } catch let error as NSError {
            print(error)
        }
        
        viewController = window?.rootViewController as? FlutterViewController
        
        MainMethodChannelHandler(viewController: viewController!).register()
        actionMethodChannelHandler = ActionMethodChannelHandler(viewController: viewController!)
        actionMethodChannelHandler?.register()
        MessagingMethodChannelHandler(viewController: viewController!, appDelegate: self).register()
        
        initNotificationCategories()
        
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        actionMethodChannelHandler?.invokeAction(actionName: url.host!, arguments: url.queryParams())
        return true
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // TODO: Separate on notification action tapped from on notification content tapped
        actionMethodChannelHandler?.invokeAction(actionName: response.actionIdentifier, arguments: response.notification.request.content.userInfo as! [String: String])
        completionHandler()
    }
    
    func initNotificationCategories() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.setNotificationCategories([
            UNNotificationCategory(identifier: "reminder", actions: [
                UNNotificationAction(identifier: "openCreateNewPage", title: "新規作成", options: [.foreground])
            ], intentIdentifiers: [], options: []),
            UNNotificationCategory(identifier: "timetable", actions: [], intentIdentifiers: [], options: []),
            UNNotificationCategory(identifier: "digestive", actions: [
                UNNotificationAction(identifier: "openFocusTimerPage", title: "集中タイマー", options: [.foreground]),
                UNNotificationAction(identifier: "deleteDigestive", title: "Digestiveを削除", options: []),
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
        
        if fcmToken != nil, let user = Auth.auth().currentUser {
//            Firestore.firestore().document("users/\(user.uid)").setData(["notificationTokens": FieldValue.arrayUnion([fcmToken!])], merge: true)
        }
    }
}
