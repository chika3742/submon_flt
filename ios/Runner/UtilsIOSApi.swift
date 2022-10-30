import Foundation
import AppTrackingTransparency
import SafariServices
import AuthenticationServices
import WidgetKit
import Flutter

class UtilsIOSApi: NSObject, FLTUtilsApi {    
    let viewController: FlutterViewController

    init(viewController: FlutterViewController) {
        self.viewController = viewController
    }
    
    func openWebPage(withTitle title: String, url: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        let next = SFSafariViewController(url: URL(string: url)!)
        next.modalPresentationStyle = .pageSheet
        self.viewController.present(next, animated: true, completion: nil)
    }
    
    func openSignInCustomTab(withUrl url: String, completion: @escaping (FLTSignInCallback?, FlutterError?) -> Void) {
        let session = ASWebAuthenticationSession(url: URL(string: url)!, callbackURLScheme: "submon") { (url, error) in
            if let url = url {
                completion(FLTSignInCallback.make(withUri: url.absoluteString), nil)
            } else {
                completion(nil, FlutterError(code: "platform-error", message: "An error occured during authentication session.", details: error))
            }
        }
        session.presentationContextProvider = self
        session.start()
    }
    
    func updateWidgets(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func requestIDFA(completion: @escaping (NSNumber?, FlutterError?) -> Void) {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                let authorized = status == .authorized
                completion(authorized as NSNumber, nil)
            })
        } else {
            completion(1, nil)
        }
    }
    
    func setWakeLock(_ wakeLock: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        UIApplication.shared.isIdleTimerDisabled = wakeLock == 1
    }
    
    func setFullscreen(_ fullscreen: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        viewController.navigationController?.navigationBar.isHidden = fullscreen == 1
    }
}

extension UtilsIOSApi : ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return viewController.view!.window!
    }
}
