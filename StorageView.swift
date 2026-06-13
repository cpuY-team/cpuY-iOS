import SwiftUI

struct StorageView: View {
    @State private var totalStorage: String = "Loading..."
    @State private var usedStorage: String = "Loading..."
    @State private var freeStorage: String = "Loading..."
    @State private var usedPercentage: Double = 0.0

    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    Text("Storage Usage")
                        .font(.headline)

                    ProgressView(value: usedPercentage)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .padding(.vertical, 5)
                }

                infoRow(label: "Used Storage", value: usedStorage)
                infoRow(label: "Free Storage", value: freeStorage)
                infoRow(label: "Total Storage", value: totalStorage)

                Text("Values are estimated and automatically updated every 2 seconds.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
            .navigationTitle("Storage")
            .onAppear {
                updateStorageInfo()
            }
            .onReceive(timer) { _ in
                updateStorageInfo()
            }
        }
    }

    func updateStorageInfo() {
        if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let totalSpace = attributes[.systemSize] as? NSNumber,
           let freeSpace = attributes[.systemFreeSize] as? NSNumber {

            let total = Double(truncating: totalSpace) / (1024 * 1024 * 1024)
            let free = Double(truncating: freeSpace) / (1024 * 1024 * 1024)
            let used = total - free
            let percentUsed = used / total

            totalStorage = String(format: "%.2f GB", total)
            freeStorage = String(format: "%.2f GB", free)
            usedStorage = String(format: "%.2f GB", used)
            usedPercentage = percentUsed
        } else {
            totalStorage = "Error"
            freeStorage = "Error"
            usedStorage = "Error"
            usedPercentage = 0.0
        }
    }
}

