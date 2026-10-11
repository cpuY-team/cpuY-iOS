import ActivityKit
import WidgetKit
import SwiftUI

private struct StatusPresentation {
    let icon: String
    let color: Color
    let headline: String

    init(_ state: DeviceStatusActivityAttributes.ContentState) {
        // Priority: thermal (safety) > low battery (urgent) > low power mode > charging > pinned-only.
        if state.reasons.contains(.thermal) {
            icon = state.thermalStateText == "Critical" ? "flame.fill" : "thermometer.high"
            color = state.thermalStateText == "Critical" ? .red : .orange
            headline = "Running Hot (\(state.thermalStateText))"
        } else if state.reasons.contains(.lowBattery) {
            icon = "battery.25"
            color = .red
            headline = "Low Battery \(Int(state.batteryLevel * 100))%"
        } else if state.reasons.contains(.lowPowerMode) {
            icon = "bolt.slash.fill"
            color = .yellow
            headline = "Low Power Mode"
        } else if state.reasons.contains(.charging) {
            icon = state.isFull ? "battery.100.bolt" : "bolt.fill"
            color = .green
            headline = state.isFull ? "Fully Charged" : "Charging \(Int(state.batteryLevel * 100))%"
        } else {
            icon = "cpu"
            color = .indigo
            headline = "Device Status"
        }
    }
}

struct DeviceStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeviceStatusActivityAttributes.self) { context in
            let presentation = StatusPresentation(context.state)

            HStack(spacing: 16) {
                Image(systemName: presentation.icon)
                    .font(.title2)
                    .foregroundStyle(presentation.color)

                VStack(alignment: .leading, spacing: 2) {
                    Text(context.attributes.deviceName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(presentation.headline)
                        .font(.headline)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("Battery \(Int(context.state.batteryLevel * 100))%")
                        .font(.caption2)
                    Text("RAM \(context.state.ramUsedText)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    if context.state.reasons.contains(.charging), let start = context.state.chargingStartDate {
                        Text(start, style: .timer)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.8))
            .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            let presentation = StatusPresentation(context.state)

            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    ZStack {
                        Circle()
                            .fill(presentation.color.opacity(0.18))
                        Image(systemName: presentation.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(presentation.color)
                    }
                    .frame(width: 36, height: 36)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(context.state.batteryLevel * 100))%")
                            .font(.title3.bold())
                            .monospacedDigit()
                        if context.state.reasons.contains(.charging), let start = context.state.chargingStartDate {
                            Text(start, style: .timer)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.attributes.deviceName)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(presentation.headline)
                            .font(.subheadline.bold())
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Divider()
                        .padding(.bottom, 2)
                    HStack(spacing: 20) {
                        Label(context.state.thermalStateText, systemImage: "thermometer.medium")
                        Label("RAM \(context.state.ramUsedText)", systemImage: "memorychip")
                        Spacer(minLength: 0)
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            } compactLeading: {
                Image(systemName: presentation.icon)
                    .foregroundStyle(presentation.color)
            } compactTrailing: {
                Text("\(Int(context.state.batteryLevel * 100))%")
                    .monospacedDigit()
            } minimal: {
                Image(systemName: presentation.icon)
                    .foregroundStyle(presentation.color)
            }
        }
    }
}
