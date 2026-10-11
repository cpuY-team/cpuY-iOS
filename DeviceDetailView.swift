import SwiftUI

struct DeviceDetailView: View {
    let device: Device

    var body: some View {
        List {
            Section("General") {
                InfoRow(label: "Name", value: device.name, icon: "iphone", iconColor: .blue)
                InfoRow(label: "Release Year", value: "\(device.year)", icon: "calendar", iconColor: .red)
            }
            Section("Hardware") {
                InfoRow(label: "Chip", value: device.chip, icon: "cpu", iconColor: .indigo)
                InfoRow(label: "RAM", value: device.ram, icon: "memorychip", iconColor: .indigo)
                InfoRow(label: "Storage", value: device.storage, icon: "internaldrive", iconColor: .gray)
                InfoRow(label: "Battery", value: device.battery, icon: "battery.100", iconColor: .green)
                InfoRow(label: "Connector", value: device.connector, icon: "cable.connector", iconColor: .gray)
            }
            Section("Display") {
                InfoRow(label: "Display", value: device.display, icon: "display", iconColor: .purple)
            }
            Section("Features") {
                InfoRow(label: "Face ID", value: device.faceID ? "Yes" : "No", icon: "faceid", iconColor: .green)
                InfoRow(label: "Touch ID", value: device.touchID ? "Yes" : "No", icon: "touchid", iconColor: .green)
                InfoRow(label: "Dynamic Island", value: device.dynamicIsland ? "Yes" : "No", icon: "capsule.fill", iconColor: .black)
                InfoRow(label: "Wireless Charging", value: device.wirelessCharging ? "Yes" : "No", icon: "bolt.horizontal.fill", iconColor: .orange)
                InfoRow(label: "Apple Intelligence", value: device.appleIntelligence ? "Yes" : "No", icon: "sparkles", iconColor: .purple)
            }
        }
        .navigationTitle(device.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
