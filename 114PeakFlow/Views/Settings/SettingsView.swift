//
//  SettingsView.swift
//  114PeakFlow
//

import StoreKit
import SwiftUI
import UIKit

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                PeakScreenBackground()

                ScrollView {
                    VStack(spacing: 14) {
                        settingsRow(
                            title: "Rate us",
                            icon: "star.fill",
                            action: rateApp
                        )

                        settingsRow(
                            title: "Privacy",
                            icon: "hand.raised.fill",
                            action: { openPolicy(.privacyPolicy) }
                        )

                        settingsRow(
                            title: "Terms",
                            icon: "doc.text.fill",
                            action: { openPolicy(.termsOfUse) }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(PeakGradients.titleShine)
                }
            }
            .toolbarBackground(Color.peakBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    private func settingsRow(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.peakSuccess.opacity(0.18))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(PeakGradients.titleShine)
                }

                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.35))
            }
            .padding(16)
            .peakElevatedSurface(cornerRadius: 16, elevation: .card)
        }
        .buttonStyle(.plain)
    }

    private func openPolicy(_ link: PeakExternalLink) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }

    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

#Preview {
    SettingsView()
}
