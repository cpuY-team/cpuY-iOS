import SwiftUI

struct AccessibilityView: View {
    @State private var voiceOver = UIAccessibility.isVoiceOverRunning
    @State private var reduceMotion = UIAccessibility.isReduceMotionEnabled
    @State private var boldText = UIAccessibility.isBoldTextEnabled
    @State private var increaseContrast = UIAccessibility.isDarkerSystemColorsEnabled
    @State private var reduceTransparency = UIAccessibility.isReduceTransparencyEnabled
    @State private var grayscale = UIAccessibility.isGrayscaleEnabled
    @State private var switchControl = UIAccessibility.isSwitchControlRunning
    @State private var assistiveTouch = UIAccessibility.isAssistiveTouchRunning
    @State private var onOffLabels = UIAccessibility.isOnOffSwitchLabelsEnabled
    @State private var textSize = AccessibilityView.friendlyTextSize(UIApplication.shared.preferredContentSizeCategory)

    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        List {
            Section("Vision") {
                InfoRow(label: "VoiceOver", value: voiceOver ? "On" : "Off", icon: "speaker.wave.2.fill", iconColor: .blue)
                InfoRow(label: "Increase Contrast", value: increaseContrast ? "On" : "Off", icon: "circle.lefthalf.filled", iconColor: .blue)
                InfoRow(label: "Reduce Transparency", value: reduceTransparency ? "On" : "Off", icon: "square.on.square", iconColor: .blue)
                InfoRow(label: "Bold Text", value: boldText ? "On" : "Off", icon: "bold", iconColor: .blue)
                InfoRow(label: "Grayscale", value: grayscale ? "On" : "Off", icon: "circle.righthalf.filled", iconColor: .blue)
                InfoRow(label: "Larger Text", value: textSize, icon: "textformat.size", iconColor: .blue)
            }
            Section("Interaction") {
                InfoRow(label: "Reduce Motion", value: reduceMotion ? "On" : "Off", icon: "figure.walk.motion", iconColor: .green)
                InfoRow(label: "Switch Control", value: switchControl ? "On" : "Off", icon: "switch.2", iconColor: .green)
                InfoRow(label: "AssistiveTouch", value: assistiveTouch ? "On" : "Off", icon: "hand.point.up.left.fill", iconColor: .green)
                InfoRow(label: "On/Off Labels", value: onOffLabels ? "On" : "Off", icon: "textformat.abc", iconColor: .green)
            }
        }
        .navigationTitle("Accessibility")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: refresh)
        .onReceive(timer) { _ in refresh() }
    }

    private func refresh() {
        voiceOver = UIAccessibility.isVoiceOverRunning
        reduceMotion = UIAccessibility.isReduceMotionEnabled
        boldText = UIAccessibility.isBoldTextEnabled
        increaseContrast = UIAccessibility.isDarkerSystemColorsEnabled
        reduceTransparency = UIAccessibility.isReduceTransparencyEnabled
        grayscale = UIAccessibility.isGrayscaleEnabled
        switchControl = UIAccessibility.isSwitchControlRunning
        assistiveTouch = UIAccessibility.isAssistiveTouchRunning
        onOffLabels = UIAccessibility.isOnOffSwitchLabelsEnabled
        textSize = Self.friendlyTextSize(UIApplication.shared.preferredContentSizeCategory)
    }

    private static func friendlyTextSize(_ category: UIContentSizeCategory) -> String {
        switch category {
        case .extraSmall: return "Extra Small"
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large (Default)"
        case .extraLarge: return "Extra Large"
        case .extraExtraLarge: return "Extra Extra Large"
        case .extraExtraExtraLarge: return "Extra Extra Extra Large"
        case .accessibilityMedium: return "Accessibility Medium"
        case .accessibilityLarge: return "Accessibility Large"
        case .accessibilityExtraLarge: return "Accessibility Extra Large"
        case .accessibilityExtraExtraLarge: return "Accessibility Extra Extra Large"
        case .accessibilityExtraExtraExtraLarge: return "Accessibility Extra Extra Extra Large"
        default: return "Unknown"
        }
    }
}
