import Foundation
import UIKit

/// Resolves the raw hardware identifier (e.g. "iPhone17,2") that `uname()` reports
/// into the marketing name and Apple silicon chip it actually corresponds to.
/// Apple exposes no public API for this — every device-info app on the App Store
/// ships an identifier table like this one, refreshed as new hardware ships.
enum DeviceIdentity {

    struct Match {
        let marketingName: String
        let chip: String
    }

    /// iPhone1,1 ... iPhone18,5 (the original 2007 iPhone through the 2026 iPhone 17e / iPhone Air lineup).
    private static let table: [String: Match] = [
        "iPhone1,1": Match(marketingName: "iPhone (1st generation)", chip: "Samsung S5L8900"),
        "iPhone1,2": Match(marketingName: "iPhone 3G", chip: "Samsung S5L8900"),
        "iPhone2,1": Match(marketingName: "iPhone 3GS", chip: "Samsung S5L8920"),
        "iPhone3,1": Match(marketingName: "iPhone 4", chip: "A4"),
        "iPhone3,2": Match(marketingName: "iPhone 4", chip: "A4"),
        "iPhone3,3": Match(marketingName: "iPhone 4", chip: "A4"),
        "iPhone4,1": Match(marketingName: "iPhone 4s", chip: "A5"),
        "iPhone5,1": Match(marketingName: "iPhone 5", chip: "A6"),
        "iPhone5,2": Match(marketingName: "iPhone 5", chip: "A6"),
        "iPhone5,3": Match(marketingName: "iPhone 5c", chip: "A6"),
        "iPhone5,4": Match(marketingName: "iPhone 5c", chip: "A6"),
        "iPhone6,1": Match(marketingName: "iPhone 5s", chip: "A7"),
        "iPhone6,2": Match(marketingName: "iPhone 5s", chip: "A7"),
        "iPhone7,1": Match(marketingName: "iPhone 6 Plus", chip: "A8"),
        "iPhone7,2": Match(marketingName: "iPhone 6", chip: "A8"),
        "iPhone8,1": Match(marketingName: "iPhone 6s", chip: "A9"),
        "iPhone8,2": Match(marketingName: "iPhone 6s Plus", chip: "A9"),
        "iPhone8,4": Match(marketingName: "iPhone SE (1st generation)", chip: "A9"),
        "iPhone9,1": Match(marketingName: "iPhone 7", chip: "A10 Fusion"),
        "iPhone9,3": Match(marketingName: "iPhone 7", chip: "A10 Fusion"),
        "iPhone9,2": Match(marketingName: "iPhone 7 Plus", chip: "A10 Fusion"),
        "iPhone9,4": Match(marketingName: "iPhone 7 Plus", chip: "A10 Fusion"),
        "iPhone10,1": Match(marketingName: "iPhone 8", chip: "A11 Bionic"),
        "iPhone10,4": Match(marketingName: "iPhone 8", chip: "A11 Bionic"),
        "iPhone10,2": Match(marketingName: "iPhone 8 Plus", chip: "A11 Bionic"),
        "iPhone10,5": Match(marketingName: "iPhone 8 Plus", chip: "A11 Bionic"),
        "iPhone10,3": Match(marketingName: "iPhone X", chip: "A11 Bionic"),
        "iPhone10,6": Match(marketingName: "iPhone X", chip: "A11 Bionic"),
        "iPhone11,2": Match(marketingName: "iPhone XS", chip: "A12 Bionic"),
        "iPhone11,4": Match(marketingName: "iPhone XS Max", chip: "A12 Bionic"),
        "iPhone11,6": Match(marketingName: "iPhone XS Max", chip: "A12 Bionic"),
        "iPhone11,8": Match(marketingName: "iPhone XR", chip: "A12 Bionic"),
        "iPhone12,1": Match(marketingName: "iPhone 11", chip: "A13 Bionic"),
        "iPhone12,3": Match(marketingName: "iPhone 11 Pro", chip: "A13 Bionic"),
        "iPhone12,5": Match(marketingName: "iPhone 11 Pro Max", chip: "A13 Bionic"),
        "iPhone12,8": Match(marketingName: "iPhone SE (2nd generation)", chip: "A13 Bionic"),
        "iPhone13,1": Match(marketingName: "iPhone 12 mini", chip: "A14 Bionic"),
        "iPhone13,2": Match(marketingName: "iPhone 12", chip: "A14 Bionic"),
        "iPhone13,3": Match(marketingName: "iPhone 12 Pro", chip: "A14 Bionic"),
        "iPhone13,4": Match(marketingName: "iPhone 12 Pro Max", chip: "A14 Bionic"),
        "iPhone14,4": Match(marketingName: "iPhone 13 mini", chip: "A15 Bionic"),
        "iPhone14,5": Match(marketingName: "iPhone 13", chip: "A15 Bionic"),
        "iPhone14,2": Match(marketingName: "iPhone 13 Pro", chip: "A15 Bionic"),
        "iPhone14,3": Match(marketingName: "iPhone 13 Pro Max", chip: "A15 Bionic"),
        "iPhone14,6": Match(marketingName: "iPhone SE (3rd generation)", chip: "A15 Bionic"),
        "iPhone14,7": Match(marketingName: "iPhone 14", chip: "A15 Bionic"),
        "iPhone14,8": Match(marketingName: "iPhone 14 Plus", chip: "A15 Bionic"),
        "iPhone15,2": Match(marketingName: "iPhone 14 Pro", chip: "A16 Bionic"),
        "iPhone15,3": Match(marketingName: "iPhone 14 Pro Max", chip: "A16 Bionic"),
        "iPhone15,4": Match(marketingName: "iPhone 15", chip: "A16 Bionic"),
        "iPhone15,5": Match(marketingName: "iPhone 15 Plus", chip: "A16 Bionic"),
        "iPhone16,1": Match(marketingName: "iPhone 15 Pro", chip: "A17 Pro"),
        "iPhone16,2": Match(marketingName: "iPhone 15 Pro Max", chip: "A17 Pro"),
        "iPhone17,1": Match(marketingName: "iPhone 16 Pro", chip: "A18 Pro"),
        "iPhone17,2": Match(marketingName: "iPhone 16 Pro Max", chip: "A18 Pro"),
        "iPhone17,3": Match(marketingName: "iPhone 16", chip: "A18"),
        "iPhone17,4": Match(marketingName: "iPhone 16 Plus", chip: "A18"),
        "iPhone17,5": Match(marketingName: "iPhone 16e", chip: "A18"),
        "iPhone18,1": Match(marketingName: "iPhone 17 Pro", chip: "A19 Pro"),
        "iPhone18,2": Match(marketingName: "iPhone 17 Pro Max", chip: "A19 Pro"),
        "iPhone18,3": Match(marketingName: "iPhone 17", chip: "A19"),
        "iPhone18,4": Match(marketingName: "iPhone Air", chip: "A19 Pro"),
        "iPhone18,5": Match(marketingName: "iPhone 17e", chip: "A19"),
    ]

    /// The raw identifier from `uname()`, e.g. "iPhone17,2", or "x86_64"/"arm64" in the Simulator.
    static var rawIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { String(cString: $0) }
        }
    }

    /// Resolved marketing name + chip for the current device, falling back gracefully
    /// for the Simulator or hardware newer than this table.
    static var current: Match {
        resolve(rawIdentifier)
    }

    static func resolve(_ identifier: String) -> Match {
        if let known = table[identifier] {
            return known
        }
        if identifier == "x86_64" || identifier == "arm64" || identifier.contains("Simulator") {
            return Match(marketingName: "Simulator", chip: "Host Mac chip")
        }
        return Match(marketingName: UIDevice.current.model, chip: "Unknown (\(identifier))")
    }
}
