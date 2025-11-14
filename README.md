# AppBanner

A lightweight banner presenter for iOS that shows a small capsule-style card at the top of the foreground window. It is built with SwiftUI for content and UIKit for presentation, and ships with simple timing helpers for auto-dismiss behavior.

## Requirements
- iOS 18.0 or later
- Swift 6.2
- Xcode 16.1 or later

## Installation (Swift Package Manager)
Add the package in Xcode or include it in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/noppefoxwolf/AppBanner.git", from: "1.0.0")
]
```

Then add `AppBanner` to your target dependencies.

## Basic Usage
```swift
import AppBanner

func showMessageBanner() {
    var content = AppBannerContent()
    content.title = "Saved"
    content.body = "Your changes were stored successfully."

    let request = AppBannerRequest(
        identifier: UUID().uuidString,
        content: content,
        dismissTiming: TimeIntervalAppBannerDismissTiming(timeInterval: 3.0) // auto hides after 3s, swipe-up enabled
    )

    AppBannerCenter.current().add(request)
}
```

The banner appears at the top of the key window of the active foreground scene. `AppBannerCenter` manages presentation and dismissal for you.

## Progress-Driven Banner
```swift
func showProgressBanner(progress: Progress) {
    var content = AppBannerContent()
    content.title = "Uploading"
    content.body = "Closes automatically at 100%."
    content.progress = progress

    let request = AppBannerRequest(
        identifier: UUID().uuidString,
        content: content,
        dismissTiming: ProgressAppBannerDismissTiming(progress: progress) // closes when progress finishes
    )

    AppBannerCenter.current().add(request)
}
```

`ProgressAppBannerDismissTiming` listens to `fractionCompleted` and `isFinished` and dismisses when either reaches completion. Swipe-to-dismiss is disabled for progress-driven banners by default.

## Custom Dismiss Timing
`AppBannerDismissTiming` is an open base class. Subclass it to implement alternative strategies (for example, listening to a Combine publisher). Call `dismissBanner()` on your timing object to remove the banner.

## Look and Feel
- The content view uses a capsule mask with a material effect. On iOS 26 and later it uses `glassEffect`; earlier versions fall back to `.regularMaterial`.
- Minimum size: 120×36 points, with vertical padding of 6 points.

## Example App
An example project is included in `Example.swiftpm`. It demonstrates:
- A time-interval banner.
- A progress-driven banner with simulated work.

Run it from Xcode to see the banners in action.

## Notes
- `AppBannerCenter` relies on the foreground scene’s key window. If your app uses multiple scenes, it will automatically target the active one.
- The default time-interval timing enables an upward swipe gesture to dismiss early; progress timing disables the gesture to avoid accidental cancellation.

## License
MIT License. See `LICENSE` for details.
