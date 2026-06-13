//
//  ScreenView.swift
//  cpuY
//
//  Created by Nathan  on 30/06/2025.
//


import SwiftUI

struct ScreenView: View {
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                List {
                    infoRow(label: "Resolution", value: "\(Int(UIScreen.main.nativeBounds.width)) x \(Int(UIScreen.main.nativeBounds.height))")
                    infoRow(label: "Maximum Refresh Rate", value: refreshRate())
                    infoRow(label: "True Tone", value: isTrueToneAvailable() ? "Yes" : "No")
                    infoRow(label: "Brightness", value: "\(Int(UIScreen.main.brightness * 100))%")
                }
                .navigationTitle("Display")
            } else {
                // Fallback on earlier versions
            }
        }
    }

    func refreshRate() -> String {
        if #available(iOS 15.0, *) {
            let maxHz = UIScreen.main.maximumFramesPerSecond
            return "\(maxHz) Hz"
        } else {
            return "60 Hz"
        }
    }

    func isTrueToneAvailable() -> Bool {
        UIScreen.main.traitCollection.displayGamut == .P3
    }
}
