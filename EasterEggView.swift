//
//  EasterEggView.swift
//  cpuY
//
//  Created by nathan on 16/05/2025.
//

import SwiftUI
import AVKit

struct EasterEggView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "egg", withExtension: "mp4")!))
                .onAppear {
                    AVPlayer(url: Bundle.main.url(forResource: "egg", withExtension: "mp4")!).play()
                }
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text("Fermer")
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}
