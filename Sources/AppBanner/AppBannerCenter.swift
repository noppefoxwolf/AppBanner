import UIKit
import SwiftUI

public final class AppBannerCenter {
    static let shared = AppBannerCenter()
    
    public static func current() -> AppBannerCenter {
        shared
    }
    
    var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })?
            .keyWindow
    }
    
    var presentationControllers: [AppBannerPresentationController] = []
    
    public func add(_ request: AppBannerRequest) {
        guard let keyWindow else { return }
        guard presentationControllers.allSatisfy({ $0.id != request.id }) else { return }
        
        let presentationController = AppBannerPresentationController(
            id: request.id,
            request.contentView,
            dismissTiming: request.dismissTiming
        )
        presentationController.delegate = self
        presentationController.present(in: keyWindow)
        
        presentationControllers.append(presentationController)
    }
}

extension AppBannerCenter: AppBannerPresentationControllerDelegate {
    func willDisappearAppBannerController(_ controller: AppBannerPresentationController) {
        
    }
    
    func didDisappearAppBannerController(_ controller: AppBannerPresentationController) {
        presentationControllers.removeAll(where: { $0 === controller })
    }
    
    func willAppearAppBannerController(_ controller: AppBannerPresentationController) {
        
    }
    
    func didAppearAppBannerController(_ controller: AppBannerPresentationController) {
        
    }
}
