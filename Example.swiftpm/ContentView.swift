import SwiftUI

struct ContentView: View {
    let showTimeIntervalBanner: () -> Void
    let showProgressBanner: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Demo Screen")
                .font(.title3)
                .bold()

            Button(action: {
                showTimeIntervalBanner()
            }) {
                Text("TimeInterval バナーを表示")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)

            Button(action: {
                showProgressBanner()
            }) {
                Text("Progress バナーを表示")
                    .font(.headline)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    ContentView(showTimeIntervalBanner: {}, showProgressBanner: {})
}
