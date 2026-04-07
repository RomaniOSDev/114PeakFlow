//
//  AchievementCard.swift
//  114PeakFlow
//

import SwiftUI

struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        achievement.isAchieved
                            ? Color.peakSuccess.opacity(0.2)
                            : Color.white.opacity(0.06)
                    )
                    .frame(width: 56, height: 56)
                    .shadow(
                        color: achievement.isAchieved ? Color.peakSuccess.opacity(0.35) : .clear,
                        radius: 10
                    )

                Image(systemName: achievement.icon)
                    .font(.largeTitle)
                    .foregroundColor(achievement.isAchieved ? .peakSuccess : .gray)
            }

            Text(achievement.name)
                .font(.headline)
                .foregroundColor(achievement.isAchieved ? .white : .gray)
                .multilineTextAlignment(.center)

            Text(achievement.description)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            if achievement.isAchieved, let achievedAt = achievement.achievedAt {
                Text(formattedShortDate(achievedAt))
                    .font(.caption2)
                    .foregroundColor(.peakSuccess)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .peakElevatedSurface(cornerRadius: 18, elevation: achievement.isAchieved ? .raised : .card)
    }
}
