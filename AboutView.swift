import SwiftUI

struct AboutView: View {
    private var shortVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    private var bundleID: String {
        Bundle.main.bundleIdentifier ?? "—"
    }
    private var copyrightYear: String {
        String(Calendar.current.component(.year, from: Date()))
    }

    private let features: [(icon: String, color: Color, title: String)] = [
        ("iphone", .blue, "Device Info & Chip Identification"),
        ("battery.100", .green, "Battery Level & Status"),
        ("internaldrive", .gray, "Storage Usage"),
        ("cpu", .indigo, "CPU & Memory Performance"),
        ("wifi", .blue, "Network Status"),
        ("display", .purple, "Display Details"),
        ("lock.shield.fill", .green, "Biometric Security"),
        ("book.pages.fill", .orange, "Device Encyclopedia"),
    ]

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                        Text("cpuY").font(.title.bold())
                        Text("Version \(shortVersion) (\(buildNumber))").foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)

            Section("About") {
                Text("cpuY gives you a clear, at-a-glance view of your Apple device — from the exact chip inside it to live memory, storage, battery, network, and display readings.")
            }

            Section("What's Included") {
                ForEach(features, id: \.title) { feature in
                    Label {
                        Text(feature.title)
                    } icon: {
                        IconBadge(systemName: feature.icon, color: feature.color)
                    }
                }
            }

            Section("Details") {
                InfoRow(label: "Version", value: shortVersion, icon: "tag.fill", iconColor: .blue)
                InfoRow(label: "Build", value: buildNumber, icon: "hammer.fill", iconColor: .gray)
                InfoRow(label: "Bundle Identifier", value: bundleID, icon: "shippingbox.fill", iconColor: .gray)
                InfoRow(label: "Compatibility", value: "iPhone & iPad", icon: "ipad.and.iphone", iconColor: .blue)
            }

            Section {
                Text("Chip and device data is maintained manually and may not yet include the newest Apple hardware.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section {
                HStack {
                    Spacer()
                    Text("© \(copyrightYear) cpuY. All rights reserved.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}
