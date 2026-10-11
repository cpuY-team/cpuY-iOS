import SwiftUI

struct DeviceEncyclopediaView: View {
    @State private var devices: [Device] = []
    private let currentDeviceName = DeviceIdentity.current.marketingName

    var body: some View {
        List(devices) { device in
            NavigationLink(destination: DeviceDetailView(device: device)) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(device.name).font(.headline)
                        Text("\(device.year) · \(device.chip)").font(.subheadline).foregroundStyle(.secondary)
                    }
                    Spacer()
                    if device.name == currentDeviceName {
                        HighlightBadge()
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Encyclopedia")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadDevices() }
    }

    private func loadDevices() {
        guard let url = Bundle.main.url(forResource: "devices", withExtension: "json") else {
            print("devices.json was not found in the app bundle.")
            return
        }
        do {
            devices = try JSONDecoder().decode([Device].self, from: Data(contentsOf: url))
        } catch {
            print("Could not decode devices.json: \(error)")
        }
    }
}
