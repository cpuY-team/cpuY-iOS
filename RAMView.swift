import SwiftUI

struct RAMView: View {
    @State private var usedMemory: String = "Loading..."
    @State private var freeMemory: String = "Loading..."
    @State private var totalMemory: String = "Loading..."
    @State private var usagePercentage: Double = 0.0

    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    Text("RAM Usage")
                        .font(.headline)

                    ProgressView(value: usagePercentage)
                        .padding(.vertical, 5)
                }

                infoRow(label: "Used RAM", value: usedMemory)
                infoRow(label: "Free RAM", value: freeMemory)
                infoRow(label: "Total RAM", value: totalMemory)

                Text("Memory usage is estimated in GB and updated every 2 seconds.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
            .navigationTitle("RAM")
            .onAppear {
                updateMemoryInfo()
            }
            .onReceive(timer) { _ in
                updateMemoryInfo()
            }
        }
    }

    func updateMemoryInfo() {
        let total = ProcessInfo.processInfo.physicalMemory
        let totalGB = Double(total) / 1073741824.0

        var vmStats = vm_statistics64()
        var count = mach_msg_type_number_t(
            MemoryLayout.size(ofValue: vmStats) / MemoryLayout<integer_t>.size
        )

        let result = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }

        if result == KERN_SUCCESS {

            var pageSize: vm_size_t = 0
            host_page_size(mach_host_self(), &pageSize)

            let free = Double(vmStats.free_count + vmStats.inactive_count)
                * Double(pageSize) / 1073741824.0

            let used = totalGB - free

            usedMemory = String(format: "%.2f GB", used)
            freeMemory = String(format: "%.2f GB", free)
            totalMemory = String(format: "%.2f GB", totalGB)
            usagePercentage = used / totalGB
        } else {
            usedMemory = "Error"
            freeMemory = "Error"
            totalMemory = String(format: "%.2f GB", totalGB)
            usagePercentage = 0.0
        }
    }
}
