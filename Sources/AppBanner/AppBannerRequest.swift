import SwiftUI

public struct AppBannerRequest: Identifiable {
    public let id: String
    public let contentView: any View
    public let dismissTiming: AppBannerDismissTiming
    
    public init<ContentView: View>(
        identifier: String,
        contentView: ContentView,
        dismissTiming: AppBannerDismissTiming = TimeIntervalAppBannerDismissTiming()
    ) {
        self.id = identifier
        self.contentView = contentView
        self.dismissTiming = dismissTiming
    }
}

public extension AppBannerRequest {
    init(
        identifier: String,
        content: AppBannerContent,
        dismissTiming: AppBannerDismissTiming = TimeIntervalAppBannerDismissTiming()
    ) {
        let contentView = AppBannerContentView(
            icon: { EmptyView() },
            titleText: { Text(content.title) },
            bodyText: { (content.body).map({ Text($0) }) },
            accessory: { EmptyView() },
            progress: content.progress
        )
        self.init(
            identifier: identifier,
            contentView: contentView,
            dismissTiming: dismissTiming
        )
    }
}
