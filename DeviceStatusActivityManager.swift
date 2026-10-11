import Foundation
import ActivityKit
import UIKit

/// User-configurable toggles for which conditions are allowed to start a
/// Device Status Live Activity. Backed by UserDefaults so LiveActivitySettingsView
/// (via @AppStorage) and this manager always agree on the current values.
enum LiveActivitySettings {
    static let chargingEnabledKey = "liveActivity.chargingEnabled"
    static let lowBatteryEnabledKey = "liveActivity.lowBatteryEnabled"
    static let lowBatteryThresholdKey = "liveActivity.lowBatteryThreshold"
    static let thermalEnabledKey = "liveActivity.thermalEnabled"
    static let lowPowerModeEnabledKey = "liveActivity.lowPowerModeEnabled"
    /// Lets the user keep the (non-alert) activity pinned in the Dynamic Island
    /// on demand, even when none of the automatic conditions are currently true.
    static let manualPinEnabledKey = "liveActivity.manualPinEnabled"

    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            chargingEnabledKey: true,
            lowBatteryEnabledKey: true,
            lowBatteryThresholdKey: 0.20,
            thermalEnabledKey: true,
            lowPowerModeEnabledKey: true,
            manualPinEnabledKey: false,
        ])
    }

    static var chargingEnabled: Bool { UserDefaults.standard.bool(forKey: chargingEnabledKey) }
    static var lowBatteryEnabled: Bool { UserDefaults.standard.bool(forKey: lowBatteryEnabledKey) }
    static var thermalEnabled: Bool { UserDefaults.standard.bool(forKey: thermalEnabledKey) }
    static var lowPowerModeEnabled: Bool { UserDefaults.standard.bool(forKey: lowPowerModeEnabledKey) }
    static var manualPinEnabled: Bool { UserDefaults.standard.bool(forKey: manualPinEnabledKey) }
    static var lowBatteryThreshold: Double {
        let value = UserDefaults.standard.double(forKey: lowBatteryThresholdKey)
        return value > 0 ? value : 0.20
    }
}

/// Starts a single Live Activity for whichever conditions are both enabled in
/// Settings and currently true (charging, low battery, overheating), keeps it
/// updated while any condition holds, and ends it once none do.
///
/// Updates only happen while cpuY gets execution time (foreground, or a brief
/// window in the background) — there's no push server behind this, so an
/// activity left running while the app is fully backgrounded for a long time
/// won't keep refreshing until the app is reopened.
@MainActor
final class DeviceStatusActivityManager {
    static let shared = DeviceStatusActivityManager()

    /// Battery level at or below which a low-battery alert (sound/banner) fires,
    /// separate from — and stricter than — the user's configurable Low Battery
    /// Live Activity threshold, so the alert stays reserved for genuinely urgent cases.
    private static let criticalBatteryLevel: Float = 0.10

    private var activity: Activity<DeviceStatusActivityAttributes>?
    private var timer: Timer?
    private var chargingStartDate: Date?

    // De-dupe flags so an alert fires once per episode, not on every 30s update
    // while the condition remains true.
    private var alertedThermalCritical = false
    private var alertedLowBatteryCritical = false

    private init() {
        LiveActivitySettings.registerDefaults()
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(reevaluate), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reevaluate), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reevaluate), name: ProcessInfo.thermalStateDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reevaluate), name: NSNotification.Name.NSProcessInfoPowerStateDidChange, object: nil)
        // Settings toggles (charging/low battery/thermal/low power mode/manual pin)
        // are written via @AppStorage, so listen broadly rather than wiring a
        // dedicated notification per toggle.
        NotificationCenter.default.addObserver(self, selector: #selector(reevaluate), name: UserDefaults.didChangeNotification, object: nil)
        reevaluate()
    }

    @objc private func reevaluate() {
        startOrUpdateOrEnd()
    }

    private func activeReasons(battery: SystemStats.Battery, thermalState: ProcessInfo.ThermalState) -> [DeviceStatusReason] {
        var reasons: [DeviceStatusReason] = []

        if LiveActivitySettings.chargingEnabled, battery.state == .charging || battery.state == .full {
            reasons.append(.charging)
        }
        if LiveActivitySettings.lowBatteryEnabled,
           battery.state == .unplugged,
           battery.level >= 0,
           battery.level <= Float(LiveActivitySettings.lowBatteryThreshold) {
            reasons.append(.lowBattery)
        }
        if LiveActivitySettings.thermalEnabled, thermalState == .serious || thermalState == .critical {
            reasons.append(.thermal)
        }
        if LiveActivitySettings.lowPowerModeEnabled, ProcessInfo.processInfo.isLowPowerModeEnabled {
            reasons.append(.lowPowerMode)
        }
        return reasons
    }

    private func updateChargingStartDate(isCharging: Bool) {
        if isCharging {
            if chargingStartDate == nil { chargingStartDate = Date() }
        } else {
            chargingStartDate = nil
        }
    }

    private func currentState() -> (reasons: [DeviceStatusReason], state: DeviceStatusActivityAttributes.ContentState, battery: SystemStats.Battery, thermalState: ProcessInfo.ThermalState) {
        let battery = SystemStats.currentBattery()
        let memory = SystemStats.currentMemory()
        let thermalState = ProcessInfo.processInfo.thermalState
        let reasons = activeReasons(battery: battery, thermalState: thermalState)
        let isCharging = battery.state == .charging || battery.state == .full
        updateChargingStartDate(isCharging: isCharging)

        let content = DeviceStatusActivityAttributes.ContentState(
            reasons: reasons,
            batteryLevel: battery.level,
            isCharging: battery.state == .charging,
            isFull: battery.state == .full,
            ramUsedFraction: memory.usedFraction,
            ramUsedText: String(format: "%.1f GB", memory.usedGB),
            thermalStateText: Self.thermalText(thermalState),
            lastUpdated: Date(),
            chargingStartDate: chargingStartDate
        )
        return (reasons, content, battery, thermalState)
    }

    /// Returns an alert (sound + banner) for conditions that just became critical,
    /// or nil if nothing new warrants interrupting the user. Also updates the
    /// de-dupe flags so the same episode doesn't re-alert on every refresh.
    private func pendingAlert(for reasons: [DeviceStatusReason], battery: SystemStats.Battery, thermalState: ProcessInfo.ThermalState) -> AlertConfiguration? {
        var alert: AlertConfiguration?

        let thermalCritical = reasons.contains(.thermal) && thermalState == .critical
        if thermalCritical, !alertedThermalCritical {
            alert = AlertConfiguration(
                title: "Device Overheating",
                body: "Your \(DeviceIdentity.current.chip) chip has reached critical temperature. Let it cool down.",
                sound: .default
            )
        }
        alertedThermalCritical = thermalCritical

        let batteryCritical = reasons.contains(.lowBattery) && battery.level >= 0 && battery.level <= Self.criticalBatteryLevel
        if batteryCritical, !alertedLowBatteryCritical, alert == nil {
            alert = AlertConfiguration(
                title: "Battery Critically Low",
                body: "\(Int(battery.level * 100))% remaining — plug in soon.",
                sound: .default
            )
        }
        alertedLowBatteryCritical = batteryCritical

        return alert
    }

    private func startOrUpdateOrEnd() {
        var (reasons, content, battery, thermalState) = currentState()

        if reasons.isEmpty, LiveActivitySettings.manualPinEnabled {
            reasons = [.pinned]
            content.reasons = [.pinned]
        }

        guard !reasons.isEmpty else {
            alertedThermalCritical = false
            alertedLowBatteryCritical = false
            end()
            return
        }

        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let alert = pendingAlert(for: reasons, battery: battery, thermalState: thermalState)

        if let activity {
            if let alert {
                Task { await activity.update(ActivityContent(state: content, staleDate: nil), alertConfiguration: alert) }
            } else {
                Task { await activity.update(ActivityContent(state: content, staleDate: nil)) }
            }
        } else {
            let attributes = DeviceStatusActivityAttributes(
                deviceName: DeviceIdentity.current.marketingName,
                chip: DeviceIdentity.current.chip
            )
            do {
                let newActivity = try Activity.request(attributes: attributes, content: ActivityContent(state: content, staleDate: nil))
                activity = newActivity
                // The alert-configured `request(...)` overload needs iOS 26; to alert on the very
                // first appearance too (not just later updates) on our iOS 18.2 minimum, follow the
                // plain request with an immediate alert-configured update instead.
                if let alert {
                    Task { await newActivity.update(ActivityContent(state: content, staleDate: nil), alertConfiguration: alert) }
                }
                startTimer()
            } catch {
                print("Failed to start Device Status Live Activity: \(error)")
            }
        }
    }

    private func end() {
        guard let activity else { return }
        let (_, finalContent, _, _) = currentState()
        Task {
            await activity.end(ActivityContent(state: finalContent, staleDate: nil), dismissalPolicy: .after(.now.addingTimeInterval(5)))
        }
        self.activity = nil
        timer?.invalidate()
        timer = nil
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.startOrUpdateOrEnd() }
        }
    }

    private static func thermalText(_ state: ProcessInfo.ThermalState) -> String {
        switch state {
        case .nominal: return "Nominal"
        case .fair: return "Fair"
        case .serious: return "Serious"
        case .critical: return "Critical"
        @unknown default: return "Unknown"
        }
    }
}
