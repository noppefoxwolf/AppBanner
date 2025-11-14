import SwiftUI

public struct AppBannerContentView<Icon: View, Title: View, Body: View, Accessory: View>: View {
    
    @ViewBuilder
    let icon: () -> Icon
    
    @ViewBuilder
    let titleText: () -> Title
    
    @ViewBuilder
    let bodyText: () -> Body
    
    @ViewBuilder
    let accessory: (() -> Accessory)
    
    let progress: Progress?
    
    public var body: some View {
        HStack(content: {
            icon()
            
            VStack(alignment: .leading) {
                titleText()
                    .foregroundStyle(.primary)
                    .font(.caption)
                    .bold()
                
                bodyText()
                    .foregroundStyle(.secondary)
                    .font(.caption2)
            }
            
            accessory()
                .buttonStyle(.bordered)
        })
        .padding(12)
        .background(.regularMaterial)
        .overlay(alignment: .bottom) {
            if let progress {
                ProgressView(progress)
                    .progressViewStyle(.linear)
                    .labelsHidden()
            }
        }
        .overlay(content: {
            Capsule()
                .stroke(Color.white, lineWidth: 2)
                .blendMode(.overlay)
        })
        .mask(Capsule())
        .materialEffect()
        .shadow(
            color: .black.opacity(0.05),
            radius: 10,
            x: 0,
            y: 10
        )
        
    }
}


extension View {
    
    @ViewBuilder
    func materialEffect() -> some View {
        if #available(iOS 26.0, *) {
            self
                .mask(Capsule())
                .glassEffect(.regular.interactive())
        } else {
            self
                .geometryGroup()
                .background(.regularMaterial)
                .mask(Capsule())
        }
    }
}
