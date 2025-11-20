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
        BannerContainer {
            HStack(content: {
                icon()
                
                VStack(alignment: .leading) {
                    titleText()
                        .foregroundStyle(.primary)
                        .font(.caption)
                        .bold()
                        .lineLimit(1)
                    
                    bodyText()
                        .foregroundStyle(.secondary)
                        .font(.caption2)
                        .lineLimit(5)
                }
                
                accessory()
                    .buttonStyle(.bordered)
            })
            .padding(12)
            .frame(minWidth: 150)
            .overlay(alignment: .bottom) {
                if let progress {
                    ProgressView(progress)
                        .progressViewStyle(.linear)
                        .labelsHidden()
                }
            }
        }
        .frame(maxWidth: 300)
    }
}

private struct BannerContainer<Content: View>: View {
    @ViewBuilder
    let content: () -> Content
    
    var body: some View {
        if #available(iOS 26.0, *) {
            ModernBannerContainer(content: content)
        } else {
            LegacyBannerContainer(content: content)
        }
    }
}

@available(iOS 26.0, *)
private struct ModernBannerContainer<Content: View>: View {
    @ViewBuilder
    let content: () -> Content
    
    var body: some View {
        content()
            .mask(RoundedRectangle(cornerRadius: 24))
            .glassEffect(
                .regular.interactive(),
                in: RoundedRectangle(cornerRadius: 24)
            )
            .shadow(
                color: .black.opacity(0.05),
                radius: 10,
                x: 0,
                y: 10
            )
    }
}

private struct LegacyBannerContainer<Content: View>: View {
    @ViewBuilder
    let content: () -> Content
    
    var body: some View {
        content()
            .background(.regularMaterial)
            .mask(RoundedRectangle(cornerRadius: 24))
            .overlay(content: {
                RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white, lineWidth: 2)
                .blendMode(.overlay)
            })
            .shadow(
                color: .black.opacity(0.05),
                radius: 10,
                x: 0,
                y: 10
            )
    }
}

#Preview {
    @Previewable
    var progress = {
        let progress = Progress()
        progress.totalUnitCount = 100
        progress.completedUnitCount = 50
        return progress
    }()
    
    AppBannerContentView(
        icon: {},
        titleText: {
            Text("Hello, World!")
        },
        bodyText: {
            Text("Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!Hello, World!")
        },
        accessory: {},
        progress: progress
    )
    
    AppBannerContentView(
        icon: {},
        titleText: {
            Text("Hello, World!")
        },
        bodyText: {
            Text("Hello, World!")
        },
        accessory: {},
        progress: progress
    )
}
