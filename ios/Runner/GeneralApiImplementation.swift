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
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  func requestIDFA(completion: @escaping (Result<Bool, Error>) -> Void) {
    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      completion(.success(status == .authorized))
    })
  }
  
  func setWakeLock(enabled: Bool) throws {
    UIApplication.shared.isIdleTimerDisabled = enabled
  }
  
  func setFullscreen(isFullscreen: Bool) throws {
    throw FlutterError(code: "unsupported", message: "Method \"setFullscreen\" is not supported on this platform.", details: nil)
  }
}
