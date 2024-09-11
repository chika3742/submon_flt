import Foundation
import Flutter
import SafariServices
import AuthenticationServices
import WidgetKit
import AppTrackingTransparency

@objc
class MainMethodChannelHandler : NSObject {
  let methodChannel: FlutterMethodChannel
  let viewController: FlutterViewController
  var pendingUri: String? = nil
  
  init(viewController: FlutterViewController) {
    self.methodChannel = FlutterMethodChannel(name: "net.chikach.submon/main", binaryMessenger: viewController.binaryMessenger)
    self.viewController = viewController
  }
  
  func register() {
    methodChannel.setMethodCallHandler(handler)
  }
  
  private func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: String]
    
    switch call.method {
    case "openWebPage":
      openWebPage(args: args!)
      result(nil)
      break
    case "openCustomTabs":
      startAuthenticationSession(args: args!, result: result)
      break
    case "updateWidgets":
      updateWidgets()
      result(nil)
      break
    case "getPendingUri":
      result(pendingUri)
      break
    case "requestIDFA":
      requestIDFA(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func openWebPage(args: [String: String]) {
    let next = SFSafariViewController(url: URL.init(string: args["url"]!)!)
    next.modalPresentationStyle = .pageSheet
    self.viewController.present(next, animated: true, completion: nil)
  }
  
  private func startAuthenticationSession(args: [String: String], result: @escaping FlutterResult) {
    let session = ASWebAuthenticationSession(url: URL(string: args["url"]!)!, callbackURLScheme: "submon") { (url, error) in
      result(url?.absoluteString)
    }
    session.presentationContextProvider = self
    session.start()
  }
  
  private func updateWidgets() {
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  private func requestIDFA(result: @escaping FlutterResult) {
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      let authorized = status == .authorized
      result(authorized)
    })
  }
  
  func saveMessagingToken(token: String) {
    methodChannel.invokeMethod("saveMessagingToken", arguments: ["token": token])
  }
}

extension MainMethodChannelHandler : ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return viewController.view!.window!
  }
}
