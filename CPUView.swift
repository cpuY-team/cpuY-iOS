import SwiftUI

struct CPUInfo {
    let name: String
    let frequency: String
    let cores: Int
}

struct CPUView: View {
    private let cpuData: [String: CPUInfo] = [
        // --- iPhone 7 / 7 Plus ---
        "iPhone9,1": CPUInfo(name: "A10 Fusion", frequency: "2.34 GHz", cores: 4), // 7 (GSM)
        "iPhone9,3": CPUInfo(name: "A10 Fusion", frequency: "2.34 GHz", cores: 4), // 7 (Global)
        "iPhone9,2": CPUInfo(name: "A10 Fusion", frequency: "2.34 GHz", cores: 4), // 7 Plus (GSM)
        "iPhone9,4": CPUInfo(name: "A10 Fusion", frequency: "2.34 GHz", cores: 4), // 7 Plus (Global)

        // --- iPhone 8 / 8 Plus ---
        "iPhone10,1": CPUInfo(name: "A11 Bionic", frequency: "2.39 GHz", cores: 6), // 8 (GSM)
        "iPhone10,4": CPUInfo(name: "A11 Bionic", frequency: "2.39 GHz", cores: 6), // 8 (Global)
        "iPhone10,2": CPUInfo(name: "A11 Bionic", frequency: "2.39 GHz", cores: 6), // 8 Plus (GSM)
        "iPhone10,5": CPUInfo(name: "A11 Bionic", frequency: "2.39 GHz", cores: 6), // 8 Plus (Global)

        // --- iPhone X ---
        "iPhone10,3": CPUInfo(name: "A11 Bionic", frequency: "2.39 GHz", cores: 6), // X (GSM)
        "iPhone10,6": CPUInfo(name: "A11 Bionic", frequency: "2.39 GHz", cores: 6), // X (Global)

        // --- iPhone XR ---
        "iPhone11,8": CPUInfo(name: "A12 Bionic", frequency: "2.49 GHz", cores: 6),

        // --- iPhone XS / XS Max ---
        "iPhone11,2": CPUInfo(name: "A12 Bionic", frequency: "2.49 GHz", cores: 6), // XS
        "iPhone11,6": CPUInfo(name: "A12 Bionic", frequency: "2.49 GHz", cores: 6), // XS Max (Global)
        "iPhone11,4": CPUInfo(name: "A12 Bionic", frequency: "2.49 GHz", cores: 6), // XS Max (China)

        // --- iPhone 11 ---
        "iPhone12,1": CPUInfo(name: "A13 Bionic", frequency: "2.65 GHz", cores: 6),
        "iPhone12,3": CPUInfo(name: "A13 Bionic", frequency: "2.65 GHz", cores: 6), // 11 Pro
        "iPhone12,5": CPUInfo(name: "A13 Bionic", frequency: "2.65 GHz", cores: 6), // 11 Pro Max

        // --- iPhone SE (2nd gen) ---
        "iPhone12,8": CPUInfo(name: "A13 Bionic", frequency: "2.65 GHz", cores: 6),

        // --- iPhone 12 ---
        "iPhone13,1": CPUInfo(name: "A14 Bionic", frequency: "3.1 GHz", cores: 6), // 12 mini
        "iPhone13,2": CPUInfo(name: "A14 Bionic", frequency: "3.1 GHz", cores: 6), // 12
        "iPhone13,3": CPUInfo(name: "A14 Bionic", frequency: "3.1 GHz", cores: 6), // 12 Pro
        "iPhone13,4": CPUInfo(name: "A14 Bionic", frequency: "3.1 GHz", cores: 6), // 12 Pro Max

        // --- iPhone 13 ---
        "iPhone14,4": CPUInfo(name: "A15 Bionic", frequency: "3.23 GHz", cores: 6), // 13 mini
        "iPhone14,5": CPUInfo(name: "A15 Bionic", frequency: "3.23 GHz", cores: 6), // 13
        "iPhone14,2": CPUInfo(name: "A15 Bionic", frequency: "3.23 GHz", cores: 6), // 13 Pro
        "iPhone14,3": CPUInfo(name: "A15 Bionic", frequency: "3.23 GHz", cores: 6), // 13 Pro Max

        // --- iPhone SE (3rd gen) ---
        "iPhone14,6": CPUInfo(name: "A15 Bionic", frequency: "3.23 GHz", cores: 6),

        // --- iPhone 14 ---
        "iPhone14,7": CPUInfo(name: "A15 Bionic (5-core GPU)", frequency: "3.23 GHz", cores: 6), // 14
        "iPhone14,8": CPUInfo(name: "A15 Bionic (5-core GPU)", frequency: "3.23 GHz", cores: 6), // 14 Plus
        "iPhone15,2": CPUInfo(name: "A16 Bionic", frequency: "3.46 GHz", cores: 6), // 14 Pro
        "iPhone15,3": CPUInfo(name: "A16 Bionic", frequency: "3.46 GHz", cores: 6), // 14 Pro Max

        // --- iPhone 15 ---
        "iPhone15,4": CPUInfo(name: "A16 Bionic", frequency: "3.46 GHz", cores: 6), // 15
        "iPhone15,5": CPUInfo(name: "A16 Bionic", frequency: "3.46 GHz", cores: 6), // 15 Plus
        "iPhone16,1": CPUInfo(name: "A17 Pro", frequency: "3.78 GHz", cores: 6),   // 15 Pro
        "iPhone16,2": CPUInfo(name: "A17 Pro", frequency: "3.78 GHz", cores: 6),   // 15 Pro Max

        // --- iPhone 16 ---
        "iPhone17,3": CPUInfo(name: "A18", frequency: "3.90 GHz", cores: 6),       // 16
        "iPhone17,4": CPUInfo(name: "A18", frequency: "3.90 GHz", cores: 6),       // 16 Plus
        "iPhone17,1": CPUInfo(name: "A18 Pro", frequency: "4.00 GHz", cores: 6),   // 16 Pro
        "iPhone17,2": CPUInfo(name: "A18 Pro", frequency: "4.00 GHz", cores: 6),   // 16 Pro Max
        // iPhone Air (2025)
        "iPhone18,1": CPUInfo(name: "A19 Pro", frequency: "– GHz", cores: 6),
        "iPhone18,2": CPUInfo(name: "A19 Pro", frequency: "– GHz", cores: 6),

        // iPhone 17 (standard)
        "iPhone18,3": CPUInfo(name: "A19", frequency: "– GHz", cores: 6),
        "iPhone18,4": CPUInfo(name: "A19", frequency: "– GHz", cores: 6),

        // iPhone 17 Pro / Pro Max
        "iPhone18,5": CPUInfo(name: "A19 Pro", frequency: "– GHz", cores: 6),
        "iPhone18,6": CPUInfo(name: "A19 Pro", frequency: "– GHz", cores: 6)    ]

    private func modelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                if let cpu = cpuData[modelIdentifier()] {
                    infoRow(label: "Puce", value: cpu.name)
                    infoRow(label: "Fréquence", value: cpu.frequency)
                    infoRow(label: "Cœurs", value: "\(cpu.cores)")
                } else {
                    Text("Informations CPU non disponibles pour ce modèle.")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("CPU")
        }
    }
}
