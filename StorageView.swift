import SwiftUI

struct StorageView: View {
    @State private var total = "Loading..."
    @State private var used = "Loading..."
    @State private var free = "Loading..."
    @State private var percentage = 0.0
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    GlassCard {
                        Text("Storage Usage").font(.headline)
                        CapacityBar(usedFraction: percentage, tint: .blue)
                        HStack {
                            Text("\(Int(percentage * 100))% used")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(total)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                Section("Storage") {
                    InfoRow(label: "Used Storage", value: used, icon: "chart.pie.fill", iconColor: .blue)
                    InfoRow(label: "Free Storage", value: free, icon: "internaldrive", iconColor: .green)
                    InfoRow(label: "Total Storage", value: total, icon: "internaldrive.fill", iconColor: .gray)
                }
            }
            .navigationTitle("Storage")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { updateStorage() }
            .onReceive(timer) { _ in updateStorage() }
        }
    }

    private func updateStorage() {
        guard let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let totalSpace = attributes[.systemSize] as? NSNumber,
              let freeSpace = attributes[.systemFreeSize] as? NSNumber else { return }
        let t = Double(truncating: totalSpace) / 1073741824
        let f = Double(truncating: freeSpace) / 1073741824
        let u = t - f
        total = String(format: "%.2f GB", t)
        free = String(format: "%.2f GB", f)
        used = String(format: "%.2f GB", u)
        percentage = u / t
    }
}
