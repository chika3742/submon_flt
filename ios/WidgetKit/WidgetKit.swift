//
//  WidgetKit.swift
//  WidgetKit
//
//  Created by 近松 和矢 on 2022/05/25.
//

import WidgetKit
import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct WidgetKit: WidgetBundle {
    init() {
        FirebaseApp.configure()
        do {
            try Auth.auth().useUserAccessGroup("B66Z929S96.net.chikach.submon")
        } catch let error as NSError {
            print(error)
        }
    }
    
    @WidgetBundleBuilder
    var body: some Widget {
        SubmissionListWidget()
    }
}
