//
//  BrowserApiImplementation.swift
//  Runner
//
//  Created by Kazuya Chikamatsu on 2023/08/11.
//

import AuthenticationServices
import SafariServices

class BrowserApiImplementation : BrowserApi {
    internal init(viewController: FlutterViewController) {
        self.viewController = viewController
    }
    
    let viewController: FlutterViewController
    
    func openAuthCustomTab(url: String, completion: @escaping (Result<String?, Error>) -> Void) {
        completion(.failure(FlutterError(code: "unsupported", message: "Method \"openAuthCustomTab\" is not supported on this platform.", details: nil)))
    }
    
    func openWebPage(title: String, url: String) throws {
        let next = SFSafariViewController(url: URL.init(string: url)!)
        next.modalPresentationStyle = .pageSheet
        self.viewController.present(next, animated: true, completion: nil)
    }
}
