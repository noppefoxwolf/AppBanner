import Foundation

public final class TimeIntervalAppBannerDismissTiming: AppBannerDismissTiming {
    public let timeInterval: TimeInterval
    public override var enabledDismissGesture: Bool { true }
    private var timer: Timer?

    public init(timeInterval: TimeInterval = 3.0) {
        self.timeInterval = timeInterval
    }

    public override func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.delegate?.didFiredDismissTimingEvent(self)
        }
    }

    public override func stop() {
        timer?.invalidate()
        timer = nil
    }

    public override func restart() {
        stop()
        start()
    }
}

