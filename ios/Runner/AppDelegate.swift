import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let mainChannel = FlutterMethodChannel(name: "submon/main", binaryMessenger: controller.binaryMessenger)
      
      mainChannel.setMethodCallHandler({
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
      
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
