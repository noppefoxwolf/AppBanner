import Foundation

public final class ProgressAppBannerDismissTiming: AppBannerDismissTiming {
    public let progress: Progress
    public override var enabledDismissGesture: Bool { false }

    private var fractionCompletedObservation: NSKeyValueObservation?
    private var isFinishedObservation: NSKeyValueObservation?

    public init(progress: Progress) {
        self.progress = progress
        super.init()
    }

    @MainActor deinit {
        stop()
    }

    public override func start() {
        // Clear previous observations just in case
        stop()

        // If already finished, dismiss immediately
        if progress.isFinished || progress.fractionCompleted >= 1.0 {
            dismissBanner()
            return
        }

        // Observe fractionCompleted to catch reaching 1.0
        fractionCompletedObservation = progress.observe(\Progress.fractionCompleted, options: [.new]) { [weak self] progress, change in
            guard let self else { return }
            if progress.fractionCompleted >= 1.0 {
                self.dismissBanner()
            }
        }

        // Observe isFinished for explicit completion
        isFinishedObservation = progress.observe(\Progress.isFinished, options: [.new]) { [weak self] progress, change in
            guard let self else { return }
            if progress.isFinished {
                self.dismissBanner()
            }
        }
    }

    public override func stop() {
        fractionCompletedObservation?.invalidate()
        isFinishedObservation?.invalidate()
        fractionCompletedObservation = nil
        isFinishedObservation = nil
    }
}
