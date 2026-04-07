//
//  AchievementsView.swift
//  114PeakFlow
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: PeakFlowViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                PeakScreenBackground()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Achievements")
                        .font(.largeTitle)
                        .bold()
                        .peakScreenTitleStyle()
                        .padding(.horizontal)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                            ForEach(viewModel.achievements) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
