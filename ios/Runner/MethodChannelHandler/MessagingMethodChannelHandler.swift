import Foundation
import FirebaseMessaging

class MessagingMethodChannelHandler {
    let methodChannel: FlutterMethodChannel
    let viewController: FlutterViewController
    let appDelegate: AppDelegate
    
    init(viewController: FlutterViewController, appDelegate: AppDelegate) {
        self.methodChannel = FlutterMethodChannel(name: "net.chikach.submon/messaging", binaryMessenger: viewController.binaryMessenger)
        self.viewController = viewController
        self.appDelegate = appDelegate
    }
    
    func register() {
        methodChannel.setMethodCallHandler(handler)
    }
    
    private func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        let args = call.arguments as! [String: String]
        
        switch call.method {
        case "requestNotificationPermission":
            requestNotificationPermission(result: result)
            break
        case "getToken":
            Messaging.messaging().token(completion: { (token, error) in
                if error != nil {
                    result(nil)
                } else if let token = token {
                    result(token)
                }
            })
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func requestNotificationPermission(result: @escaping FlutterResult) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            if granted {
                notificationCenter.delegate = self.appDelegate
                result(NotificationPermissionState.granted.rawValue)
            } else {
                result(NotificationPermissionState.denied.rawValue)
            }
        }
    }
}

enum NotificationPermissionState: Int {
    case granted = 0
    case denied = 1
}
