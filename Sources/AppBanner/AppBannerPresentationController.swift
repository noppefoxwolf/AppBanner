import Foundation
import UIKit
import SwiftUI

protocol AppBannerPresentationControllerDelegate: AnyObject {
    func willAppearAppBannerController(_ controller: AppBannerPresentationController)
    func didAppearAppBannerController(_ controller: AppBannerPresentationController)
    func willDisappearAppBannerController(_ controller: AppBannerPresentationController)
    func didDisappearAppBannerController(_ controller: AppBannerPresentationController)
}

final class AppBannerPresentationController {
    weak var delegate: AppBannerPresentationControllerDelegate?
    
    enum Constants {
        static let appearDuration: TimeInterval = 0.5
        static let disappearDuration: TimeInterval = 0.3
        static let springDamping: CGFloat = 0.75
        static let springVelocity: CGFloat = 0.6
        static let initialTopOffset: CGFloat = -20
        static let initialScale: CGFloat = 0.96
    }
    
    let id: String
    let viewController: UIViewController
    let dismissTiming: AppBannerDismissTiming
    
    weak var containerView: UIView?
    var topConstraint: NSLayoutConstraint?
    var isPresented: Bool = false
    var isAnimating: Bool = false
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureRecognizer.cancelsTouchesInView = false
        return panGestureRecognizer
    }()
    
    init<ContentView: View>(
        id: String,
        _ contentView: ContentView,
        dismissTiming: AppBannerDismissTiming
    ) {
        let hostingController = UIHostingController(
            rootView: contentView
        )
        hostingController.view.backgroundColor = .clear
        hostingController.sizingOptions = .preferredContentSize
        hostingController.safeAreaRegions = []
        self.id = id
        self.viewController = hostingController
        self.dismissTiming = dismissTiming
    }
    
    func present(in view: UIView) {
        guard !isPresented && !isAnimating else { return }
        isAnimating = true
        containerView = view
        dismissTiming.delegate = self
        delegate?.willAppearAppBannerController(self)
        
        let contentView = prepareContentView()
        attach(contentView, to: view)
        layoutInitialPosition(on: view)
        animateIn(contentView, on: view) { [weak self] in
            guard let self else { return }
            self.isAnimating = false
            self.isPresented = true
            self.delegate?.didAppearAppBannerController(self)
            self.dismissTiming.start()
        }
    }
    
    private func prepareContentView() -> UIView {
        let contentView = viewController.view!
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: Constants.initialScale, y: Constants.initialScale)
        contentView.isUserInteractionEnabled = true
        if dismissTiming.enabledDismissGesture {
            contentView.addGestureRecognizer(panGesture)
        }
        return contentView
    }
    
    private func attach(_ contentView: UIView, to view: UIView) {
        view.addSubview(contentView)
        let top = contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.initialTopOffset)
        top.isActive = true
        topConstraint = top
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func layoutInitialPosition(on view: UIView) {
        view.layoutIfNeeded()
    }
    
    private func animateIn(_ contentView: UIView, on view: UIView, completion: @escaping () -> Void) {
        topConstraint?.constant = 0
        let animator = UIViewPropertyAnimator(duration: Constants.appearDuration, dampingRatio: Constants.springDamping) {
            contentView.alpha = 1
            contentView.transform = .identity
            view.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            completion()
        }
        animator.startAnimation()
    }
    
    private func cleanupAfterDismiss(_ contentView: UIView) {
        if dismissTiming.enabledDismissGesture {
            contentView.removeGestureRecognizer(panGesture)
        }
        contentView.removeFromSuperview()
        topConstraint = nil
        isAnimating = false
        isPresented = false
        containerView = nil
        delegate?.didDisappearAppBannerController(self)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        let velocity = gesture.velocity(in: gesture.view)
        let upwardTranslation = translation.y < -40 // threshold to avoid accidental dismiss
        let upwardVelocity = velocity.y < -600      // fling threshold

        switch gesture.state {
        case .began, .changed:
            // Keep alive while interacting
            dismissTiming.restart()
        case .ended, .cancelled, .failed:
            if dismissTiming.enabledDismissGesture && (upwardTranslation || upwardVelocity) {
                // Dismiss on upward pan
                dismiss()
            } else {
                // Otherwise restart countdown
                dismissTiming.restart()
            }
        default:
            break
        }
    }
    
    public func dismiss() {
        guard isPresented && !isAnimating, let view = containerView, let top = topConstraint else { return }
        isAnimating = true
        dismissTiming.stop()
        delegate?.willDisappearAppBannerController(self)
        
        let contentView = viewController.view!
        top.constant = Constants.initialTopOffset
        let animator = UIViewPropertyAnimator(duration: Constants.disappearDuration, curve: .easeIn) {
            contentView.alpha = 0
            contentView.transform = CGAffineTransform(scaleX: Constants.initialScale, y: Constants.initialScale)
            view.layoutIfNeeded()
        }
        animator.addCompletion { [weak self] _ in
            self?.cleanupAfterDismiss(contentView)
        }
        animator.startAnimation()
    }
}

extension AppBannerPresentationController: AppBannerDismissTimingDelegate {
    func didFiredDismissTimingEvent(_ timing: AppBannerDismissTiming) {
        dismiss()
    }
}
