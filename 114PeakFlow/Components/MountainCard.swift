//
//  MountainCard.swift
//  114PeakFlow
//

import SwiftUI

struct MountainCard: View {
    let mountain: Mountain
    var lastAscentDate: Date?

    var body: some View {
        HStack {
            Image(systemName: mountain.isClimbed ? "flag.fill" : "mountain.2.fill")
                .foregroundColor(mountain.isClimbed ? .peakSuccess : .gray)
                .font(.title2)
                .shadow(color: mountain.isClimbed ? Color.peakSuccess.opacity(0.4) : .clear, radius: 6)

            VStack(alignment: .leading) {
                HStack {
                    Text(mountain.name)
                        .foregroundColor(.white)
                        .font(.headline)

                    if mountain.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.peakSuccess)
                            .font(.caption)
                            .shadow(color: Color.peakSuccess.opacity(0.45), radius: 4)
                    }
                }

                Text("\(mountain.height) m • \(mountain.mountainRange)")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text(mountain.difficulty.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        mountain.difficulty.color.opacity(0.35),
                                        mountain.difficulty.color.opacity(0.12)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                Capsule()
                                    .strokeBorder(mountain.difficulty.color.opacity(0.45), lineWidth: 1)
                            )
                    )
                    .foregroundColor(mountain.difficulty.color)
            }

            Spacer()

            if let lastAscentDate {
                Text(formattedShortDate(lastAscentDate))
                    .font(.caption2)
                    .foregroundColor(.peakSuccess)
            }
        }
        .padding()
        .peakElevatedSurface(cornerRadius: 16, elevation: .card)
    }
}
