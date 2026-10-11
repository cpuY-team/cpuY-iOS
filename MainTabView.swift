import SwiftUI

// The TabView below already renders as a translucent, blurred Apple-standard tab bar.
// On Xcode 26 / iOS 26 this automatically becomes real Liquid Glass — no changes needed here.
struct MainTabView: View {
    var body: some View {
        TabView {
            InfoView().tabItem { Label("Info", systemImage: "iphone") }
            BatteryView().tabItem { Label("Battery", systemImage: "battery.75") }
            StorageView().tabItem { Label("Storage", systemImage: "internaldrive") }
            PerformanceView().tabItem { Label("Performance", systemImage: "cpu") }
            MoreView().tabItem { Label("More", systemImage: "ellipsis.circle") }
        }
        .onAppear {
            _ = DeviceStatusActivityManager.shared
        }
    }
}
