import SwiftUI

struct BatteryView: View {
    @State private var batteryLevelText = ""
    @State private var batteryStatusText = ""
    @State private var batteryUsageText = ""

    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }

    var body: some View {
        NavigationView {
            List {
                infoRow(label: "Battery Level", value: batteryLevelText)
                infoRow(label: "Battery Status", value: batteryStatusText)
                infoRow(label: "Estimated Usage Time", value: batteryUsageText)

                Text("Note: Since iOS 17, apps no longer have access to the exact battery level. It is rounded to 5% increments.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
            .navigationTitle("Battery")
            .onAppear {
                updateBatteryInfo()
            }
            .onReceive(timer) { _ in
                updateBatteryInfo()
            }
        }
    }

    func updateBatteryInfo() {
        batteryLevelText = batteryLevel()
        batteryStatusText = batteryStatus()
        batteryUsageText = usageTime()
    }

    func batteryLevel() -> String {
        let level = UIDevice.current.batteryLevel
        if level < 0 {
            return "Unavailable"
        } else {
            let percent = Int(level * 100)
            return "\(percent)%"
        }
    }

    func batteryStatus() -> String {
        switch UIDevice.current.batteryState {
        case .unknown:
            return "Unknown"
        case .unplugged:
            return "On Battery"
        case .charging:
            return "Charging"
        case .full:
            return "Fully Charged"
        @unknown default:
            return "Unknown"
        }
    }

    func usageTime() -> String {
        let batteryLevel = UIDevice.current.batteryLevel
        if batteryLevel < 0 {
            return "Unavailable"
        }

        let batteryPercentage = batteryLevel * 100
        let fullUsageInMinutes = 8 * 60
        let remainingMinutes = Int((batteryPercentage / 100) * Float(fullUsageInMinutes))

        let hours = remainingMinutes / 60
        let minutes = remainingMinutes % 60

        return "\(hours)h \(minutes)m estimated remaining"
    }
}


