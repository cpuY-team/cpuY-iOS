import SwiftUI
import LocalAuthentication

struct SecurityView: View {
    var body: some View {
        List {
            Section("Security") {
                InfoRow(label: "Biometrics", value: authType(), icon: biometryIcon(), iconColor: .green)
                InfoRow(label: "Passcode Set", value: passcodeSet() ? "Yes" : "No", icon: passcodeSet() ? "lock.fill" : "lock.open.fill", iconColor: passcodeSet() ? .green : .red)
            }

            Section {
                InfoRow(label: "Jailbreak Status", value: isJailbroken() ? "Detected" : "Not Detected", icon: isJailbroken() ? "exclamationmark.triangle.fill" : "checkmark.shield.fill", iconColor: isJailbroken() ? .red : .green)
            } footer: {
                Text("Jailbreak detection is a best-effort heuristic (common file paths and sandbox checks) — it can miss newer jailbreaks and, rarely, false-positive.")
            }
        }
        .navigationTitle("Security")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func authType() -> String {
        let context = LAContext(); var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return "Unavailable" }
        return context.biometryType == .faceID ? "Face ID" : context.biometryType == .touchID ? "Touch ID" : "None"
    }

    private func biometryIcon() -> String {
        let context = LAContext(); var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return "lock.slash" }
        return context.biometryType == .faceID ? "faceid" : context.biometryType == .touchID ? "touchid" : "lock"
    }

    private func passcodeSet() -> Bool {
        let context = LAContext(); var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
    }

    private func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        let suspiciousPaths = [
            "/Applications/Cydia.app",
            "/Applications/Sileo.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt",
            "/private/var/lib/cydia",
            "/bin/bash"
        ]
        if suspiciousPaths.contains(where: { FileManager.default.fileExists(atPath: $0) }) {
            return true
        }

        let testPath = "/private/cpuY-jailbreak-check-\(UUID().uuidString).txt"
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            return false
        }
        #endif
    }
}
