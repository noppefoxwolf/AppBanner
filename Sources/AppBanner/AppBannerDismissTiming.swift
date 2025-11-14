import Foundation

internal protocol AppBannerDismissTimingDelegate: AnyObject {
    func didFiredDismissTimingEvent(_ timing: AppBannerDismissTiming)
}

open class AppBannerDismissTiming {
    open var enabledDismissGesture: Bool { false }
    internal weak var delegate: AppBannerDismissTimingDelegate? = nil
    
    public func dismissBanner() {
        delegate?.didFiredDismissTimingEvent(self)
    }
    
    // Control hooks for subclasses
    open func start() {}
    open func stop() {}
    open func restart() { stop(); start() }
}

