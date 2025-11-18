import SwiftUI

struct ContentView: View {
    let showTimeIntervalBanner: () -> Void
    let showProgressBanner: () -> Void
    let showProgressCancelBanner: () -> Void
    let showLongBodyBanner: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Demo Screen")
                .font(.title3)
                .bold()

            Button(action: {
                showTimeIntervalBanner()
            }) {
                Text("Show TimeInterval banner")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)

            Button(action: {
                showProgressBanner()
            }) {
                Text("Show Progress banner")
                    .font(.headline)
            }
            .buttonStyle(.bordered)
            
            Button(action: {
                showProgressCancelBanner()
            }) {
                Text("Show Progress Cancel")
                    .font(.headline)
            }
            .buttonStyle(.bordered)

            Button(action: {
                showLongBodyBanner()
            }) {
                Text("Show Long Body banner")
                    .font(.headline)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    ContentView(showTimeIntervalBanner: {}, showProgressBanner: {}, showProgressCancelBanner: {}, showLongBodyBanner: {})
}
