import SwiftUI

struct LiveActivitySettingsView: View {
    @AppStorage(LiveActivitySettings.chargingEnabledKey) private var chargingEnabled = true
    @AppStorage(LiveActivitySettings.lowBatteryEnabledKey) private var lowBatteryEnabled = true
    @AppStorage(LiveActivitySettings.lowBatteryThresholdKey) private var lowBatteryThreshold = 0.20
    @AppStorage(LiveActivitySettings.thermalEnabledKey) private var thermalEnabled = true
    @AppStorage(LiveActivitySettings.lowPowerModeEnabledKey) private var lowPowerModeEnabled = true
    @AppStorage(LiveActivitySettings.manualPinEnabledKey) private var manualPinEnabled = false

    var body: some View {
        List {
            Section {
                Toggle(isOn: $manualPinEnabled) {
                    Label {
                        Text("Keep Pinned to Dynamic Island")
                    } icon: {
                        IconBadge(systemName: "pin.fill", color: .indigo)
                    }
                }
            } footer: {
                Text("Keeps a Device Status Live Activity active at all times, even when none of the conditions below are true — a quick glance at battery, RAM, and thermal state whenever you want it.")
            }

            Section {
                Toggle(isOn: $chargingEnabled) {
                    Label {
                        Text("Charging")
                    } icon: {
                        IconBadge(systemName: "bolt.fill", color: .green)
                    }
                }
            } footer: {
                Text("Shows a Live Activity while your phone is plugged in.")
            }

            Section {
                Toggle(isOn: $lowBatteryEnabled) {
                    Label {
                        Text("Low Battery")
                    } icon: {
                        IconBadge(systemName: "battery.25", color: .red)
                    }
                }
                if lowBatteryEnabled {
                    Stepper(value: $lowBatteryThreshold, in: 0.05...0.5, step: 0.05) {
                        InfoRow(label: "Alert Below", value: "\(Int(lowBatteryThreshold * 100))%")
                    }
                }
            } footer: {
                Text("Shows a Live Activity when your battery drops below this level while unplugged. Below 10% also sounds a one-time alert.")
            }

            Section {
                Toggle(isOn: $thermalEnabled) {
                    Label {
                        Text("Thermal Warning")
                    } icon: {
                        IconBadge(systemName: "thermometer.high", color: .orange)
                    }
                }
            } footer: {
                Text("Shows a Live Activity when your chip reaches Serious or Critical thermal state. Critical also sounds a one-time alert.")
            }

            Section {
                Toggle(isOn: $lowPowerModeEnabled) {
                    Label {
                        Text("Low Power Mode")
                    } icon: {
                        IconBadge(systemName: "bolt.slash.fill", color: .yellow)
                    }
                }
            } footer: {
                Text("Shows a Live Activity while Low Power Mode is turned on.")
            }

            Section {
                Text("If more than one condition is true at once, a single Live Activity shows all of them together instead of stacking multiple on your Lock Screen. Thermal and Low Battery alerts are the only ones that interrupt you with sound — everything else, including the pinned activity, stays silent.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Live Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
}
