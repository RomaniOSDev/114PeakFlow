//
//  FilterChip.swift
//  114PeakFlow
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(chipBackground)
                .foregroundColor(isSelected ? Color.peakBackground : color)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(
                            LinearGradient(
                                colors: isSelected
                                    ? [Color.white.opacity(0.35), color.opacity(0.5)]
                                    : [color.opacity(0.55), Color.white.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: isSelected ? color.opacity(0.45) : .black.opacity(0.35),
                    radius: isSelected ? 10 : 6,
                    x: 0,
                    y: isSelected ? 5 : 3
                )
                .shadow(
                    color: isSelected ? Color.peakSuccess.opacity(0.2) : .clear,
                    radius: 12,
                    x: 0,
                    y: 4
                )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var chipBackground: some View {
        if isSelected {
            Capsule().fill(PeakGradients.chipSelected)
        } else {
            Capsule().fill(PeakGradients.chipUnselected)
        }
    }
}
