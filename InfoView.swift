import SwiftUI
import AVKit

struct InfoView: View {
    @State private var showEasterEgg = false
    @State private var tapCount = 0

    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }

    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    tapCount += 1
                    if tapCount >= 10 {
                        showEasterEgg = true
                        tapCount = 0
                    }
                }) {
                    infoRow(label: "Model", value: modelName())
                }

                infoRow(label: "iOS Version", value: "iOS \(UIDevice.current.systemVersion)")
                infoRow(label: "Device Name", value: UIDevice.current.name)
                infoRow(label: "Identifier", value: modelIdentifier())
                infoRow(label: "Storage Capacity", value: storageCapacity())
                infoRow(label: "Free Space", value: freeStorage())
                infoRow(label: "Dynamic Island", value: hasDynamicIsland() ? "Yes" : "No")

                infoRow(label: "Battery Level", value: batteryLevelText())
                infoRow(label: "Battery State", value: batteryStateText())

                infoRow(label: "Uptime", value: uptimeFormatted())
            }
            .navigationTitle("Device Info")
            .sheet(isPresented: $showEasterEgg) {
                if let url = Bundle.main.url(forResource: "egg", withExtension: "mp4") {
                    VideoPlayer(player: AVPlayer(url: url))
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("Video not found.")
                }
            }
        }
    }

 

    // MARK: - DEVICE INFO HELPERS

    func modelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce("") { acc, element in
            guard let value = element.value as? Int8, value != 0 else { return acc }
            return acc + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    func modelName() -> String {
        let machine = modelIdentifier()

        let modelMap: [String: String] = [
            // iPhone 6s / SE 1st gen
            "iPhone8,1": "iPhone 6s",
            "iPhone8,4": "iPhone SE (1st gen)",
            // iPhone 7 / 7 Plus
            "iPhone9,1": "iPhone 7 (Global)",
            "iPhone9,2": "iPhone 7 Plus (Global)",
            "iPhone9,3": "iPhone 7 (GSM)",
            "iPhone9,4": "iPhone 7 Plus (GSM)",
            // iPhone 8 / 8 Plus / X
            "iPhone10,1": "iPhone 8 (Global)",
            "iPhone10,2": "iPhone 8 Plus (Global)",
            "iPhone10,3": "iPhone X (Global)",
            "iPhone10,4": "iPhone 8 (GSM)",
            "iPhone10,5": "iPhone 8 Plus (GSM)",
            "iPhone10,6": "iPhone X (GSM)",
            // iPhone XR / XS / XS Max
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max",
            "iPhone11,6": "iPhone XS Max",
            "iPhone11,8": "iPhone XR",
            // iPhone 11 / Pro / Pro Max
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            // SE 2
            "iPhone12,8": "iPhone SE (2nd gen)",
            // iPhone 12 series
            "iPhone13,1": "iPhone 12 mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            // iPhone 13 series
            "iPhone14,4": "iPhone 13 mini",
            "iPhone14,5": "iPhone 13",
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            // SE 3
            "iPhone14,6": "iPhone SE (3rd gen)",
            // iPhone 14 / 14 Plus / 14 Pro / Pro Max
            "iPhone14,7": "iPhone 14",
            "iPhone14,8": "iPhone 14 Plus",
            "iPhone15,2": "iPhone 14 Pro",
            "iPhone15,3": "iPhone 14 Pro Max",
            // iPhone 15 series
            "iPhone15,4": "iPhone 15",
            "iPhone15,5": "iPhone 15 Plus",
            "iPhone16,1": "iPhone 15 Pro",
            "iPhone16,2": "iPhone 15 Pro Max",
            // iPhone 16 series
            "iPhone16,4": "iPhone 16",
            "iPhone16,5": "iPhone 16 Plus",
            "iPhone17,1": "iPhone 16 Pro",
            "iPhone17,2": "iPhone 16 Pro Max",
            // Hypothetical / new models
            "iPhone18,1": "iPhone Air",
            "iPhone18,2": "iPhone Air",
            "iPhone18,3": "iPhone 17",
            "iPhone18,4": "iPhone 17",
            "iPhone18,5": "iPhone 17 Pro",
            "iPhone18,6": "iPhone 17 Pro Max"
        ]

        return modelMap[machine] ?? machine
    }

    func storageCapacity() -> String {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let totalSize = attrs[.systemSize] as? NSNumber {
            let totalGB = Double(truncating: totalSize) / (1024 * 1024 * 1024)
            return String(format: "%.0f GB", totalGB)
        }
        return "Unknown"
    }

    func freeStorage() -> String {
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let freeSize = attrs[.systemFreeSize] as? NSNumber {
            let freeGB = Double(truncating: freeSize) / (1024 * 1024 * 1024)
            return String(format: "%.1f GB free", freeGB)
        }
        return "Unknown"
    }

    func hasDynamicIsland() -> Bool {
        let modelsWithIsland = [
            "iPhone15,2", "iPhone15,3",
            "iPhone16,1", "iPhone16,2",
            "iPhone17,1", "iPhone17,2",
            "iPhone18,5", "iPhone18,6"
        ]
        return modelsWithIsland.contains(modelIdentifier())
    }

    func batteryLevelText() -> String {
        let level = UIDevice.current.batteryLevel
        if level < 0 { return "Unknown" }
        return "\(Int(level * 100))%"
    }

    func batteryStateText() -> String {
        switch UIDevice.current.batteryState {
        case .unknown: return "Unknown"
        case .unplugged: return "Unplugged"
        case .charging: return "Charging"
        case .full: return "Full"
        @unknown default: return "Unknown"
        }
    }

    func uptimeFormatted() -> String {
        let seconds = Int(ProcessInfo.processInfo.systemUptime)
        let days = seconds / 86400
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        if days > 0 { return "\(days)d \(hours)h \(minutes)m" }
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }

    func formattedDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: date)
    }
}



// MARK: - SHARE SHEET
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}
extension URL: @retroactive Identifiable {
    public var id: String {
        absoluteString
    }
}
