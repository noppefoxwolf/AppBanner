import Foundation
import Combine

public final class ProgressAppBannerDismissTiming: AppBannerDismissTiming {
    public let progress: Progress
    public override var enabledDismissGesture: Bool { false }

    private var fractionCompletedObservation: AnyCancellable?
    private var isFinishedObservation: AnyCancellable?

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
        fractionCompletedObservation = progress
            .publisher(for: \.fractionCompleted)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fractionCompleted in
                guard let self else { return }
                if fractionCompleted >= 1.0 {
                    self.dismissBanner()
                }
            })

        // Observe isFinished for explicit completion
        isFinishedObservation = progress
            .publisher(for: \.isFinished)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isFinished in
                guard let self else { return }
                if isFinished {
                    self.dismissBanner()
                }
            })
    }

    public override func stop() {
        fractionCompletedObservation = nil
        isFinishedObservation = nil
    }
}
