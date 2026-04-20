import UIKit
import Flutter
import AuthenticationServices
import SafariServices
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    var uriEventApi: UriEventApi?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initNotificationCategories()
        
        UNUserNotificationCenter.current().delegate = self

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func didInitializeImplicitFlutterEngine(_ engineBridge: any FlutterImplicitEngineBridge) {
        let binaryMessenger = engineBridge.applicationRegistrar.messenger()
        
        // Event Channels
        uriEventApi = UriEventApi(binaryMessenger: binaryMessenger)
        uriEventApi!.initHandler()
        
        // Register plugins
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }
    
    override func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        switch response.notification.request.content.categoryIdentifier {
        case "reminder":
            if response.actionIdentifier == "openCreateSubmission" {
                openAppPath(path: "/create-submission")
            }
            break;
            
        case "digestive":
            if response.actionIdentifier == "openFocusTimer" {
                openAppPath(path: "/focus-timer?digestiveId=\(userInfo["digestiveId"] ?? "-1")")
            } else {
                if (userInfo["submissionId"] as? String? != "-1") {
                    openAppPath(path: "/submission?id=\(userInfo["submissionId"] ?? "-1")")
                } else {
                    openAppPath(path: "/tab/digestive")
                }
            }
            
        case "timetable":
            openAppPath(path: "/tab/timetable")
            
        default: break
        }
        completionHandler()
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

func openAppPath(path: String) {
    UIApplication.shared.open(URL(string: "submon://\(path)")!, options: [:], completionHandler: nil)
}
