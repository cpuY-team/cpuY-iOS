import SwiftUI
import Network

struct NetworkView: View {
    @State private var monitor: NWPathMonitor?
    @State private var isConnected = false
    @State private var connectionType = "Checking…"
    @State private var isExpensive = false
    @State private var isConstrained = false

    private let queue = DispatchQueue(label: "cpuY.NetworkMonitor")

    var body: some View {
        List {
            Section("Connection") {
                InfoRow(
                    label: "Status",
                    value: isConnected ? "Connected" : "No Connection",
                    icon: isConnected ? "checkmark.circle.fill" : "xmark.circle.fill",
                    iconColor: isConnected ? .green : .red
                )
                InfoRow(label: "Connection Type", value: connectionType, icon: connectionIcon, iconColor: .blue)
            }
            Section("Details") {
                InfoRow(label: "Low Data Mode", value: isConstrained ? "On" : "Off", icon: "tortoise.fill", iconColor: .orange)
                InfoRow(label: "Uses Cellular Data", value: isExpensive ? "Yes" : "No", icon: "antenna.radiowaves.left.and.right", iconColor: .blue)
            }
        }
        .navigationTitle("Network")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { startMonitoring() }
        .onDisappear {
            monitor?.cancel()
            monitor = nil
        }
    }

    private var connectionIcon: String {
        switch connectionType {
        case "Wi-Fi": return "wifi"
        case "Cellular": return "antenna.radiowaves.left.and.right"
        case "Wired Ethernet": return "cable.connector"
        default: return "wifi.slash"
        }
    }

    private func startMonitoring() {
        let m = NWPathMonitor()
        m.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                isConnected = path.status == .satisfied
                isExpensive = path.isExpensive
                isConstrained = path.isConstrained
                if path.usesInterfaceType(.wifi) {
                    connectionType = "Wi-Fi"
                } else if path.usesInterfaceType(.cellular) {
                    connectionType = "Cellular"
                } else if path.usesInterfaceType(.wiredEthernet) {
                    connectionType = "Wired Ethernet"
                } else if path.status == .satisfied {
                    connectionType = "Other"
                } else {
                    connectionType = "No Connection"
                }
            }
        }
        m.start(queue: queue)
        monitor = m
    }
}
