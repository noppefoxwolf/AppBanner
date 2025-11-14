import Foundation

public struct AppBannerContent: Sendable {
    public var title: String = ""
    public var body: String? = nil
    public var progress: Progress? = nil
    
    public init() {}
}
