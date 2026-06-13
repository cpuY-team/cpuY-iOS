//
//  AboutView.swift
//  cpuY
//
//  Created by Nathan Bertrand on 06/06/2026.
//



import SwiftUI
import UIKit

struct AboutView: View {

    var body: some View {
        NavigationView {
            List {

                // Header
                Section {
                    VStack(spacing: 12) {

                        Image("cpuYLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 22))

                        Text("cpuY")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("System Monitor for iPhone")
                            .foregroundColor(.secondary)

                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                // App Information
                Section("Application") {
                    infoRow(
                        label: "Version",
                        value: appVersion()
                    )

                    infoRow(
                        label: "Build",
                        value: appBuild()
                    )
                }

                // System
                Section("System") {
                    infoRow(
                        label: "iOS Version",
                        value: UIDevice.current.systemVersion
                    )
                }

                // Developer
                Section("Developer") {
                    infoRow(
                        label: "Developer",
                        value: "Nathan Bertrand"
                    )

                    infoRow(
                        label: "Project",
                        value: "cpuY"
                    )
                }

                // About cpuY
                Section("About cpuY") {
                    Text("""
cpuY is a lightweight system monitor designed for iPhone.

The application provides detailed information about hardware, battery, storage, RAM, CPU, network, display and security.

cpuY focuses on a clean and simple interface while displaying useful system information.
""")
                }

                // Credits
                Section("Credits") {

                    Label(
                        "Built with SwiftUI",
                        systemImage: "swift"
                    )

                    Label(
                        "Powered by Apple APIs",
                        systemImage: "apple.logo"
                    )

                    Label(
                        "Designed for iPhone",
                        systemImage: "iphone"
                    )
                }

                // Footer
                Section {
                    VStack(spacing: 4) {

                        Text("cpuY")
                            .fontWeight(.bold)

                        Text("© 2026 Nathan Bertrand")
                            .font(.caption)
                            .foregroundColor(.secondary)

                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("About")
        }
    }

    private func appVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    private func appBuild() -> String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}

#Preview {
    AboutView()
}
