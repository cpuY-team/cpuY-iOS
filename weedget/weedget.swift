import WidgetKit
import SwiftUI

struct DeviceEntry: TimelineEntry {
    let date: Date
    let chip: String
    let batteryLevel: Float
    let batteryState: UIDevice.BatteryState
    let ramUsedFraction: Double
    let ramUsedText: String
    let ramTotalText: String

    static let placeholder = DeviceEntry(
        date: .now,
        chip: "Apple Silicon",
        batteryLevel: 0.72,
        batteryState: .unplugged,
        ramUsedFraction: 0.45,
        ramUsedText: "3.6 GB",
        ramTotalText: "8 GB"
    )
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DeviceEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (DeviceEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DeviceEntry>) -> Void) {
        let entry = currentEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func currentEntry() -> DeviceEntry {
        let battery = SystemStats.currentBattery()
        let memory = SystemStats.currentMemory()
        return DeviceEntry(
            date: Date(),
            chip: DeviceIdentity.current.chip,
            batteryLevel: battery.level,
            batteryState: battery.state,
            ramUsedFraction: memory.usedFraction,
            ramUsedText: String(format: "%.1f GB", memory.usedGB),
            ramTotalText: String(format: "%.0f GB", memory.totalGB)
        )
    }
}

struct weedgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    private var batteryPercentText: String {
        entry.batteryLevel < 0 ? "—" : "\(Int(entry.batteryLevel * 100))%"
    }

    private var batteryTint: Color {
        if entry.batteryState == .charging || entry.batteryState == .full { return .green }
        return entry.batteryLevel >= 0 && entry.batteryLevel < 0.2 ? .red : .green
    }

    var body: some View {
        switch family {
        case .accessoryCircular:
            Gauge(value: Double(max(entry.batteryLevel, 0))) {
                Image(systemName: "bolt.fill")
            } currentValueLabel: {
                Text(batteryPercentText)
                    .font(.system(size: 13, weight: .semibold))
            }
            .gaugeStyle(.accessoryCircular)
            .containerBackground(.clear, for: .widget)

        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.chip)
                    .font(.headline)
                    .lineLimit(1)
                Text("\(batteryPercentText) battery · \(entry.ramUsedText) used")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .containerBackground(.clear, for: .widget)

        case .accessoryInline:
            Text("\(entry.chip) · \(batteryPercentText)")
                .containerBackground(.clear, for: .widget)

        case .systemMedium:
            HStack(spacing: 20) {
                RingGauge(
                    value: Double(max(entry.batteryLevel, 0)),
                    label: "Battery",
                    valueText: batteryPercentText,
                    tint: batteryTint,
                    lineWidth: 8,
                    diameter: 84
                )
                RingGauge(
                    value: entry.ramUsedFraction,
                    label: "of \(entry.ramTotalText)",
                    valueText: entry.ramUsedText,
                    tint: .indigo,
                    lineWidth: 8,
                    diameter: 84
                )
                VStack(alignment: .leading, spacing: 4) {
                    Text("cpuY").font(.caption).foregroundStyle(.secondary)
                    Text(entry.chip).font(.headline).lineLimit(2)
                }
                Spacer(minLength: 0)
            }
            .padding(4)
            .containerBackground(.fill.tertiary, for: .widget)

        default:
            VStack(spacing: 8) {
                RingGauge(
                    value: Double(max(entry.batteryLevel, 0)),
                    label: "Battery",
                    valueText: batteryPercentText,
                    tint: batteryTint,
                    lineWidth: 9,
                    diameter: 84
                )
                Text(entry.chip)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

struct weedget: Widget {
    let kind: String = "weedget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            weedgetEntryView(entry: entry)
        }
        .configurationDisplayName("cpuY")
        .description("Battery, RAM, and chip at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

#Preview(as: .systemSmall) {
    weedget()
} timeline: {
    DeviceEntry.placeholder
}

#Preview(as: .systemMedium) {
    weedget()
} timeline: {
    DeviceEntry.placeholder
}
