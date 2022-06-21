//
//  MyAppCheckPrividerFactory.swift
//  Runner
//
//  Created by 近松 和矢 on 2022/06/21.
//

import Foundation
import Firebase
import FirebaseAppCheck

class MyAppCheckProviderFactory : NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14.0, *) {
          return AppAttestProvider(app: app)
        } else {
          return DeviceCheckProvider(app: app)
        }
    }
}
