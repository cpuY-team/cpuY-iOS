import SwiftUI
import Metal

struct PerformanceView: View {
    @State private var usedMemory = "Loading..."
    @State private var freeMemory = "Loading..."
    @State private var totalMemory = "Loading..."
    @State private var usagePercentage = 0.0
    @State private var thermalState = ProcessInfo.processInfo.thermalState
    @State private var lowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    private let identity = DeviceIdentity.current
    private let rawIdentifier = DeviceIdentity.rawIdentifier

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HeroHeader(
                        systemImage: "cpu",
                        title: identity.chip,
                        subtitle: "Apple Silicon",
                        tint: .indigo
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
                }

                Section("Chip") {
                    InfoRow(label: "Chip", value: identity.chip, icon: "cpu", iconColor: .indigo)
                    InfoRow(label: "Model Identifier", value: rawIdentifier, icon: "number", iconColor: .gray)
                    InfoRow(label: "CPU Cores", value: "\(ProcessInfo.processInfo.activeProcessorCount)", icon: "square.grid.3x3", iconColor: .orange)
                }

                Section {
                    InfoRow(label: "Thermal State", value: thermalStateText, icon: thermalStateIcon, iconColor: thermalStateColor)
                    InfoRow(label: "Low Power Mode", value: lowPowerMode ? "On" : "Off", icon: "bolt.slash.fill", iconColor: lowPowerMode ? .yellow : .gray)
                } header: {
                    Text("System")
                } footer: {
                    Text("Thermal state reflects how hard the chip is being pushed — it can rise under sustained load even if performance still feels normal.")
                }

                Section("GPU") {
                    InfoRow(label: "GPU", value: gpuName, icon: "cpu.fill", iconColor: .purple)
                    InfoRow(label: "GPU Family", value: gpuFamily, icon: "square.stack.3d.up.fill", iconColor: .purple)
                    InfoRow(label: "Ray Tracing", value: supportsRayTracing ? "Supported" : "Not Supported", icon: "light.beacon.max.fill", iconColor: supportsRayTracing ? .green : .gray)
                }

                Section("Memory") {
                    GlassCard {
                        HStack {
                            Spacer()
                            RingGauge(
                                value: usagePercentage,
                                label: "of \(totalMemory)",
                                valueText: usedMemory,
                                tint: .indigo
                            )
                            Spacer()
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)

                    InfoRow(label: "Used RAM", value: usedMemory, icon: "memorychip", iconColor: .indigo)
                    InfoRow(label: "Free RAM", value: freeMemory, icon: "memorychip", iconColor: .green)
                    InfoRow(label: "Total RAM", value: totalMemory, icon: "memorychip.fill", iconColor: .gray)
                }
            }
            .navigationTitle("Performance")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { refresh() }
            .onReceive(timer) { _ in refresh() }
        }
    }

    private var thermalStateText: String {
        switch thermalState {
        case .nominal: return "Nominal"
        case .fair: return "Fair"
        case .serious: return "Serious"
        case .critical: return "Critical"
        @unknown default: return "Unknown"
        }
    }

    private var thermalStateIcon: String {
        switch thermalState {
        case .nominal: return "thermometer.low"
        case .fair: return "thermometer.medium"
        case .serious, .critical: return "thermometer.high"
        @unknown default: return "thermometer.medium"
        }
    }

    private var thermalStateColor: Color {
        switch thermalState {
        case .nominal: return .green
        case .fair: return .yellow
        case .serious: return .orange
        case .critical: return .red
        @unknown default: return .gray
        }
    }

    private var gpuName: String {
        MTLCreateSystemDefaultDevice()?.name ?? "Unavailable"
    }

    private var gpuFamily: String {
        guard let device = MTLCreateSystemDefaultDevice() else { return "Unknown" }
        let families: [(MTLGPUFamily, String)] = [
            (.apple10, "Apple10"),
            (.apple9, "Apple9"),
            (.apple8, "Apple8"),
            (.apple7, "Apple7"),
            (.apple6, "Apple6"),
            (.apple5, "Apple5"),
            (.apple4, "Apple4"),
            (.apple3, "Apple3"),
            (.apple2, "Apple2"),
            (.apple1, "Apple1")
        ]
        for (family, label) in families where device.supportsFamily(family) {
            return label
        }
        return "Unknown"
    }

    private var supportsRayTracing: Bool {
        MTLCreateSystemDefaultDevice()?.supportsRaytracing ?? false
    }

    private func refresh() {
        thermalState = ProcessInfo.processInfo.thermalState
        lowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        updateMemoryInfo()
    }

    private func updateMemoryInfo() {
        let memory = SystemStats.currentMemory()
        totalMemory = String(format: "%.2f GB", memory.totalGB)
        freeMemory = String(format: "%.2f GB", memory.freeGB)
        usedMemory = String(format: "%.2f GB", memory.usedGB)
        usagePercentage = memory.usedFraction
    }
}
