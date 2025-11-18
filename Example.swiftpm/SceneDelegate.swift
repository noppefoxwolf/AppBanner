import UIKit
import SwiftUI
import AppBanner

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(
                rootView: ContentView(
                    showTimeIntervalBanner: {
                        var content = AppBannerContent()
                        content.title = "Hello, World! (closes in 3 seconds)"
                        let request = AppBannerRequest(
                            identifier: UUID().uuidString,
                            content: content,
                            dismissTiming: TimeIntervalAppBannerDismissTiming(timeInterval: 3.0)
                        )
                        AppBannerCenter.current().add(request)
                    },
                    showProgressBanner: {
                        let progress = Progress(totalUnitCount: 100)
                        var content = AppBannerContent()
                        content.title = "Progress Banner"
                        content.body = "Closes automatically when finished"
                        content.progress = progress
                        let request = AppBannerRequest(
                            identifier: UUID().uuidString,
                            content: content,
                            dismissTiming: ProgressAppBannerDismissTiming(progress: progress)
                        )
                        AppBannerCenter.current().add(request)

                        // Simulate progress updates
                        Task { @MainActor in
                            for i in 1...100 {
                                try? await Task.sleep(nanoseconds: 30_000_000) // 0.03s
                                progress.completedUnitCount = Int64(i)
                            }
                        }
                    },
                    showProgressCancelBanner: {
                        let progress = Progress(totalUnitCount: 100)
                        var content = AppBannerContent()
                        content.title = "Progress Banner"
                        content.body = "Closes automatically when finished"
                        content.progress = progress
                        let request = AppBannerRequest(
                            identifier: UUID().uuidString,
                            content: content,
                            dismissTiming: ProgressAppBannerDismissTiming(progress: progress)
                        )
                        AppBannerCenter.current().add(request)

                        // Simulate progress updates
                        Task { @MainActor in
                            for i in 1...50 {
                                try? await Task.sleep(nanoseconds: 30_000_000) // 0.03s
                                progress.completedUnitCount = Int64(i)
                            }
                            progress.cancel()
                        }
                    }
                )
            )
            window.makeKeyAndVisible()
            self.window = window
        }
    }
}

final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
    
}

