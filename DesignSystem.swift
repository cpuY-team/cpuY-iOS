import SwiftUI

// MARK: - Glass card
//
// Stand-in for Liquid Glass until Xcode 26 / the iOS 26 SDK is installed.
// `.glassEffect(in:)` and `GlassEffectContainer` don't exist in the iOS 18 SDK, so this
// uses `.ultraThinMaterial` to get the same translucent, floating-card look today.
// To upgrade later, wrap the `background` line below in:
//   #if canImport(SwiftUI) && compiler(>=6.2)
//     .glassEffect(.regular, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
//   #else
//     .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
//   #endif
struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 20
    var content: Content

    init(cornerRadius: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Settings-style leading icon badge

struct IconBadge: View {
    let systemName: String
    var color: Color = .accentColor

    var body: some View {
        RoundedRectangle(cornerRadius: 7, style: .continuous)
            .fill(color.gradient)
            .frame(width: 28, height: 28)
            .overlay(
                Image(systemName: systemName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            )
    }
}

// MARK: - Hero header used at the top of each tab

struct HeroHeader: View {
    let systemImage: String
    let title: String
    let subtitle: String
    var tint: Color = .accentColor

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(tint.gradient)
                    .frame(width: 64, height: 64)
                Image(systemName: systemImage)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.title2.bold())
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
    }
}

// MARK: - Circular ring gauge (RAM / battery / storage)

struct RingGauge: View {
    var value: Double
    var label: String
    var valueText: String
    var tint: Color = .accentColor
    var lineWidth: CGFloat = 12
    var diameter: CGFloat = 128

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.primary.opacity(0.08), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0.0006, min(value, 1)))
                .stroke(tint.gradient, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: value)
            VStack(spacing: 2) {
                Text(valueText)
                    .font(.title2.bold())
                    .monospacedDigit()
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(8)
        }
        .frame(width: diameter, height: diameter)
    }
}

// MARK: - Linear capacity bar (Settings-style "iPhone Storage")

struct CapacityBar: View {
    var usedFraction: Double
    var tint: Color = .blue
    var height: CGFloat = 14

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(Color.primary.opacity(0.08))
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(LinearGradient(colors: [tint, tint.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                    .frame(width: geo.size.width * CGFloat(max(0, min(usedFraction, 1))))
                    .animation(.easeInOut(duration: 0.5), value: usedFraction)
            }
        }
        .frame(height: height)
    }
}

// MARK: - "Your device" badge used in the Encyclopedia

struct HighlightBadge: View {
    var text: String = "Your Device"
    var body: some View {
        Text(text)
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.accentColor.gradient, in: Capsule())
    }
}
