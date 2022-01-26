import UIKit
import Flutter
import AuthenticationServices
import SafariServices
import Firebase
import WidgetKit

let mainChannel = "submon/main"
let notifChannel = "submon/notification"
let actionsChannel = "submon/actions"

@available(iOS 13.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var binaryMessenger : FlutterBinaryMessenger? = nil
    var controller : FlutterViewController? = nil
    
    var session : ASWebAuthenticationSession? = nil
    
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
        
        controller = window?.rootViewController as? FlutterViewController
        binaryMessenger = controller!.binaryMessenger
        let mainMethodChannel = FlutterMethodChannel(name: mainChannel, binaryMessenger: controller!.binaryMessenger)
        let notifMethodChannel = FlutterMethodChannel(name: notifChannel, binaryMessenger: controller!.binaryMessenger)
        
        let notifCenter = UNUserNotificationCenter.current()
        
        notifCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            if granted {
                notifCenter.delegate = self
            }
        }
        
        let createAction = UNNotificationAction(identifier: "create_new", title: "新規作成", options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "reminder", actions: [createAction], intentIdentifiers: [], options: [])
        
        notifCenter.setNotificationCategories([category])
        
        mainMethodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            let args = call.arguments as? Dictionary<String, String>
            switch call.method {
            case "openWebPage":
                let next = SFSafariViewController(url: URL.init(string: args!["url"]!)!)
                next.modalPresentationStyle = .pageSheet
                self.controller!.present(next, animated: true, completion: nil)
                result(nil)
                break
            case "openCustomTabs":
                self.session = ASWebAuthenticationSession(url: URL(string: args!["url"]!)!, callbackURLScheme: "submon") { (url, error) in
                    result(url?.absoluteString)
                }
                self.session!.presentationContextProvider = self
                self.session!.start()
                break
            case "updateWidgets":
                if #available(iOS 14.0, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
                break
            default:
                result(FlutterMethodNotImplemented)
                break
            }
        })
        
        notifMethodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            let args = call.arguments as? Dictionary<String, Any> ?? [:]
            
            switch call.method {
            case "isGranted":
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    result(settings.authorizationStatus == UNAuthorizationStatus.authorized)
                }
                break
            case "registerReminder":
                let content = UNMutableNotificationContent()
                content.title = args["title"] as! String
                content.body = args["body"] as! String
                content.sound = .defaultCritical
                content.categoryIdentifier = "reminder"
                
                let trigger: UNCalendarNotificationTrigger
                
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                
                dateComponents.hour = args["hour"] as? Int
                dateComponents.minute = args["minute"] as? Int
                
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest.init(identifier: "reminder", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
                result(nil)
                break;
            case "unregisterReminder":
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["reminder"])
                result(nil)
                break
            default:
                
                break;
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        switch (url.host) {
        case "createNew":
            let notifMethodChannel = FlutterMethodChannel(name: actionsChannel, binaryMessenger: binaryMessenger!)
            notifMethodChannel.invokeMethod("openCreateNewPage", arguments: nil)
            break
        default: break
        }
        return true
    }
    
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if binaryMessenger != nil {
            switch (response.actionIdentifier) {
            case "create_new":
                let notifMethodChannel = FlutterMethodChannel(name: actionsChannel, binaryMessenger: binaryMessenger!)
                notifMethodChannel.invokeMethod("openCreateNewPage", arguments: nil)
                break
            default:
                break
            }
        }
        completionHandler()
    }
    
}

@available(iOS 13.0, *)
extension AppDelegate : ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return controller!.view!.window!
    }
}
