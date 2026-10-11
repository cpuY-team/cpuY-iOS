import SwiftUI
import UIKit

struct InfoRow: View {
    let label: String
    let value: String
    var icon: String? = nil
    var iconColor: Color = .accentColor

    var body: some View {
        HStack(spacing: 12) {
            if let icon {
                IconBadge(systemName: icon, color: iconColor)
            }
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
        }
        .padding(.vertical, icon == nil ? 0 : 2)
        .contentShape(Rectangle())
        .contextMenu {
            Button {
                UIPasteboard.general.string = value
            } label: {
                Label("Copy \"\(value)\"", systemImage: "doc.on.doc")
            }
        }
    }
}
