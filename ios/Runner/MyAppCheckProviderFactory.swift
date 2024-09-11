//
//  MyAppCheckPrividerFactory.swift
//  Runner
//
//  Created by 近松 和矢 on 2022/06/21.
//

import Foundation
import FirebaseCore
import FirebaseAppCheck

class MyAppCheckProviderFactory : NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}
