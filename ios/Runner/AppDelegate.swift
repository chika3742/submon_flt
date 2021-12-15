import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var binaryMessenger : FlutterBinaryMessenger? = nil
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        binaryMessenger = controller.binaryMessenger
        let mainMethodChannel = FlutterMethodChannel(name: "submon/main", binaryMessenger: controller.binaryMessenger)
        let ntfcMethodChannel = FlutterMethodChannel(name: "submon/notification", binaryMessenger: controller.binaryMessenger)

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
          if granted {
              UNUserNotificationCenter.current().delegate = self
          }
        }

        mainMethodChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
              case "openWebPage":
                  let next = controller.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                  let args = call.arguments as! Dictionary<String, String>
                  next.url = args["url"]
                  next.title = args["title"]
                  controller.present(next, animated: true, completion: nil)
                  result(nil)
              default:
                  break
              }
        })
        
        ntfcMethodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            let args = call.arguments as! Dictionary<String, Any>
            
            switch call.method {
            case "registerAt":
                let content = UNMutableNotificationContent()
                content.title = args["title"] as! String
                content.body = args["body"] as! String
                
                let date = Date(timeIntervalSince1970: TimeInterval(args["timeSinceEpoch"] as! Int))
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest.init(identifier: (args["id"] as! String?) ?? UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
                break;
            default:
                break;
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert])
    }
}
