import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct Widgets: WidgetBundle {
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
