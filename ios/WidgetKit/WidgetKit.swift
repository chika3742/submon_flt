//
//  WidgetKit.swift
//  WidgetKit
//
//  Created by 近松 和矢 on 2022/05/25.
//

import WidgetKit
import SwiftUI

@main
struct WidgetKit: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        SubmissionListWidget()
    }
}
