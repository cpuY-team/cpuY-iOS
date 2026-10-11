import SwiftUI

struct BatteryView: View {
    @State private var level: Float = 0
    @State private var status = "Unknown"
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    init() { UIDevice.current.isBatteryMonitoringEnabled = true }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    GlassCard {
                        HStack {
                            Spacer()
                            RingGauge(
                                value: Double(max(level, 0)),
                                label: status,
                                valueText: level < 0 ? "—" : "\(Int(level * 100))%",
                                tint: tint
                            )
                            Spacer()
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                Section {
                    InfoRow(label: "Battery Level", value: levelText, icon: "battery.100", iconColor: tint)
                    InfoRow(label: "Battery Status", value: status, icon: statusIcon, iconColor: tint)
                } header: {
                    Text("Battery")
                } footer: {
                    Text("Note: since iOS 17, apps can no longer read the exact battery percentage — only an approximate value rounded to the nearest 5%, refreshed every 2 seconds.")
                }
            }
            .navigationTitle("Battery")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { refresh() }
            .onReceive(timer) { _ in refresh() }
        }
    }

    private var levelText: String {
        level < 0 ? "Unavailable" : "\(Int(level * 100))%"
    }

    private var statusIcon: String {
        switch UIDevice.current.batteryState {
        case .charging: return "bolt.fill"
        case .full: return "battery.100.bolt"
        case .unplugged: return "battery.50"
        default: return "battery.0"
        }
    }

    private var tint: Color {
        switch UIDevice.current.batteryState {
        case .charging, .full: return .green
        default: return level >= 0 && level < 0.2 ? .red : .green
        }
    }

    private func refresh() {
        level = UIDevice.current.batteryLevel
        switch UIDevice.current.batteryState {
        case .charging: status = "Charging"
        case .full: status = "Full"
        case .unplugged: status = "Unplugged"
        default: status = "Unknown"
        }
    }
}
