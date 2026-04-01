import UIKit
import Flutter

class SceneDelegate: FlutterSceneDelegate {

    override func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        super.scene(scene, openURLContexts: URLContexts)
        for context in URLContexts {
            AppDelegate.shared.uriEventApi?.onUri(uri: context.url.absoluteString)
        }
    }

    override func scene(
        _ scene: UIScene,
        continue userActivity: NSUserActivity
    ) {
        super.scene(scene, continue: userActivity)
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingUrl = userActivity.webpageURL else {
            return
        }
        AppDelegate.shared.uriEventApi?.onUri(uri: incomingUrl.absoluteString)
    }

    override func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        completionHandler(handleShortcutItem(shortcutItem))
    }
    
    private func handleShortcutItem(_ item: UIApplicationShortcutItem) -> Bool {
        switch item.type {
        case "CreateSubmissionAction":
            openAppPath(path: "/create-submission")
            break
            
        case "DigestiveTabAction":
            openAppPath(path: "/tab/digestive")
            break
            
        case "TimetableTabAction":
            openAppPath(path: "/tab/timetable")
            break
            
        default: return false
        }
        
        return true
    }
}
