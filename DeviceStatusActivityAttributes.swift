import ActivityKit
import Foundation

/// Shared between the cpuY app (which starts/updates/ends the activity) and the
/// weedget extension (which renders it on the Lock Screen and Dynamic Island).
///
/// A single activity can be active for more than one reason at once (e.g. charging
/// while also running hot) — `reasons` lists everything currently true so the
/// widget can decide what to lead with.
enum DeviceStatusReason: String, Codable, Hashable {
    case charging
    case lowBattery
    case thermal
    case lowPowerMode
    /// Not a real condition — set when the user manually pins the activity via
    /// Settings even though nothing else currently warrants it.
    case pinned
}

struct DeviceStatusActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var reasons: [DeviceStatusReason]
        var batteryLevel: Float
        var isCharging: Bool
        var isFull: Bool
        var ramUsedFraction: Double
        var ramUsedText: String
        var thermalStateText: String
        var lastUpdated: Date
        /// When the current charging session began, so the widget can render a
        /// live-ticking `Text(date, style: .timer)` without needing app updates.
        /// Nil while not charging.
        var chargingStartDate: Date?
    }

    var deviceName: String
    var chip: String
}
