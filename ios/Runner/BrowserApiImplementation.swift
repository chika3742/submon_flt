//
//  BrowserApiImplementation.swift
//  Runner
//
//  Created by Kazuya Chikamatsu on 2023/08/11.
//

import AuthenticationServices
import SafariServices

class BrowserApiImplementation : BrowserApi {
    
    func openAuthCustomTab(url: String, completion: @escaping (Result<String?, Error>) -> Void) {
        completion(.failure(PigeonError(code: "unsupported", message: "Method \"openAuthCustomTab\" is not supported on this platform.", details: nil)))
    }
    
    func openWebPage(title: String, url: String) throws {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }
        let rootVC: UIViewController?
        if #available(iOS 15.0, *) {
            rootVC = scene.keyWindow?.rootViewController
        } else {
            rootVC = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        }
        guard let rootVC else {
            return
        }
        let next = SFSafariViewController(url: URL.init(string: url)!)
        next.modalPresentationStyle = .pageSheet
        rootVC.present(next, animated: true, completion: nil)
    }
}
