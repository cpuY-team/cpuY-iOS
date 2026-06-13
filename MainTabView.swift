
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            InfoView()
                .tabItem {
                    Label("Info", systemImage: "iphone")
                }

            BatteryView()
                .tabItem {
                    Label("Battery", systemImage: "battery.75")
                }

            StorageView()
                .tabItem {
                    Label("Storage", systemImage: "externaldrive")
                }

            RAMView()
                .tabItem {
                    Label("RAM", systemImage: "memorychip")
                }

            CPUView()
                .tabItem {
                    Label("CPU", systemImage: "cpu")
                }

            NetworkView()
                .tabItem {
                    Label("Network", systemImage: "wifi")
                }

            ScreenView()
                .tabItem {
                    Label("Display", systemImage: "display")
                }

            SecurityView()
                .tabItem {
                    Label("Security", systemImage: "lock.shield")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}


