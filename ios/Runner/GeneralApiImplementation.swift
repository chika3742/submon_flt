//
//  GeneralApiImplementation.swift
//  Runner
//
//  Created by Kazuya Chikamatsu on 2023/08/13.
//

import WidgetKit
import AppTrackingTransparency

class GeneralApiImplementation : GeneralApi {
    
    func updateWidgets() throws {
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func requestIDFA(completion: @escaping (Result<Bool, Error>) -> Void) {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                completion(.success(status == .authorized))
            })
        } else {
            completion(.success(true)) // always allowed before iOS 14.0
        }
    }
    
    func setWakeLock(enabled: Bool) throws {
        UIApplication.shared.isIdleTimerDisabled = enabled
    }
    
    func setFullscreen(isFullscreen: Bool) throws {
        throw FlutterError(code: "unsupported", message: "Method \"setFullscreen\" is not supported on this platform.", details: nil)
    }
}
