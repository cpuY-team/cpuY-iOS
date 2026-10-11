import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink { NetworkView() } label: {
                        Label { Text("Network") } icon: { IconBadge(systemName: "wifi", color: .blue) }
                    }
                    NavigationLink { ScreenView() } label: {
                        Label { Text("Display") } icon: { IconBadge(systemName: "display", color: .purple) }
                    }
                    NavigationLink { SecurityView() } label: {
                        Label { Text("Security") } icon: { IconBadge(systemName: "lock.shield.fill", color: .green) }
                    }
                    NavigationLink { SensorsView() } label: {
                        Label { Text("Sensors") } icon: { IconBadge(systemName: "gyroscope", color: .teal) }
                    }
                    NavigationLink { AccessibilityView() } label: {
                        Label { Text("Accessibility") } icon: { IconBadge(systemName: "accessibility", color: .blue) }
                    }
                }
                Section {
                    NavigationLink { LiveActivitySettingsView() } label: {
                        Label { Text("Live Activity") } icon: { IconBadge(systemName: "bolt.badge.clock.fill", color: .yellow) }
                    }
                }
                Section {
                    NavigationLink { DeviceEncyclopediaView() } label: {
                        Label { Text("Device Encyclopedia") } icon: { IconBadge(systemName: "book.pages.fill", color: .orange) }
                    }
                }
                Section {
                    NavigationLink { AboutView() } label: {
                        Label { Text("About cpuY") } icon: { IconBadge(systemName: "info.circle.fill", color: .gray) }
                    }
                }
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
