import Foundation
import Flutter

class ActionMethodChannelHandler {
    let methodChannel: FlutterMethodChannel
    let viewController: FlutterViewController
    
    init(viewController: FlutterViewController) {
        self.methodChannel = FlutterMethodChannel(name: "net.chikach.submon/action", binaryMessenger: viewController.binaryMessenger)
        self.viewController = viewController
    }
    
    func register() {
        methodChannel.setMethodCallHandler(handler)
    }
    
    private func handler(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        let args = call.arguments as! [String: String]
        
        switch call.method {
        case "getPendingAction":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func invokeAction(actionName: String, arguments: [String: String]) {
        switch (actionName) {
        case "openCreateNewPage":
            methodChannel.invokeMethod(actionName, arguments: nil)
            break
        case "openSubmissionDetailPage":
            methodChannel.invokeMethod(actionName, arguments: [
                "submissionId": arguments["submissionId"]
            ])
        case "openFocusTimerPage":
            methodChannel.invokeMethod(actionName, arguments: [
                "digestiveId": arguments["digestiveId"]
            ])
            break
        default: break
        }
    }
}
