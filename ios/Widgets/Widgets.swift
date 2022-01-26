import SwiftUI
import Firebase

@main
struct Widgets: WidgetBundle {
    init() {
        FirebaseApp.configure()
        do {
            try Auth.auth().useUserAccessGroup("4L354SDDCC.net.chikach.submon")
        } catch let error as NSError {
            print(error)
        }
    }
    @WidgetBundleBuilder
    var body: some Widget {
        SubmissionListWidget()
    }
}
