import SwiftUI

struct ScreenView: View {
    var body: some View {
        List {
            Section("Display") {
                InfoRow(
                    label: "Resolution",
                    value: "\(Int(UIScreen.main.nativeBounds.width)) × \(Int(UIScreen.main.nativeBounds.height))",
                    icon: "aspectratio",
                    iconColor: .purple
                )
                InfoRow(
                    label: "Maximum Refresh Rate",
                    value: "\(UIScreen.main.maximumFramesPerSecond) Hz",
                    icon: "waveform",
                    iconColor: .purple
                )
                InfoRow(
                    label: "Brightness",
                    value: "\(Int(UIScreen.main.brightness * 100))%",
                    icon: "sun.max.fill",
                    iconColor: .yellow
                )
            }
        }
        .navigationTitle("Display")
        .navigationBarTitleDisplayMode(.inline)
    }
}
