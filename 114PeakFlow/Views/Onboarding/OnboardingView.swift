//
//  OnboardingView.swift
//  114PeakFlow
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var page = 0

    var body: some View {
        ZStack {
            PeakScreenBackground()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip") {
                        completeOnboarding()
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white.opacity(0.65))
                    .padding(.trailing, 20)
                    .padding(.top, 12)
                }

                TabView(selection: $page) {
                    OnboardingPageView(
                        icon: "mountain.2.fill",
                        iconGradient: true,
                        title: "Plan every climb",
                        subtitle: "Log ascents, routes, weather, and team details. Keep a clear history of each summit."
                    )
                    .tag(0)

                    OnboardingPageView(
                        icon: "figure.run",
                        iconGradient: false,
                        title: "Train and gear up",
                        subtitle: "Schedule training, manage your pack list, and set goals for the peaks you want next."
                    )
                    .tag(1)

                    OnboardingPageView(
                        icon: "lock.shield.fill",
                        iconGradient: false,
                        title: "Everything on your device",
                        subtitle: "No accounts or cloud required. Your notes and stats stay private on this iPhone."
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                pageDots

                bottomButtons
                    .padding(.horizontal, 24)
                    .padding(.bottom, 36)
                    .padding(.top, 8)
            }
        }
    }

    private var pageDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(i == page ? Color.peakSuccess : Color.white.opacity(0.22))
                    .frame(width: i == page ? 22 : 8, height: 8)
                    .animation(.spring(response: 0.35, dampingFraction: 0.75), value: page)
            }
        }
        .padding(.bottom, 16)
    }

    private var bottomButtons: some View {
        HStack(spacing: 14) {
            if page > 0 {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                        page -= 1
                    }
                } label: {
                    Text("Back")
                        .font(.headline)
                        .foregroundStyle(PeakGradients.titleShine)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .peakElevatedSurface(cornerRadius: 16, elevation: .soft)
                }
            }

            Button {
                if page < 2 {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                        page += 1
                    }
                } else {
                    completeOnboarding()
                }
            } label: {
                Text(page < 2 ? "Next" : "Get started")
                    .font(.headline.weight(.bold))
                    .foregroundColor(Color.peakBackground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(PeakGradients.accentButton)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.28), lineWidth: 1)
                            )
                    )
                    .shadow(color: .black.opacity(0.38), radius: 10, x: 0, y: 6)
                    .shadow(color: Color.peakSuccess.opacity(0.38), radius: 16, x: 0, y: 5)
            }
        }
    }

    private func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}

// MARK: - Page

private struct OnboardingPageView: View {
    let icon: String
    var iconGradient: Bool
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 20)

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.peakSuccess.opacity(0.35),
                                Color.peakSuccess.opacity(0.08),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)

                ZStack {
                    Circle()
                        .fill(PeakGradients.cardFill)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .strokeBorder(PeakGradients.edgeHighlight, lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.45), radius: 20, x: 0, y: 12)
                        .shadow(color: Color.peakSuccess.opacity(0.2), radius: 24, x: 0, y: 8)

                    Group {
                        if iconGradient {
                            Image(systemName: icon)
                                .font(.system(size: 48, weight: .medium))
                                .foregroundStyle(PeakGradients.titleShine)
                        } else {
                            Image(systemName: icon)
                                .font(.system(size: 48, weight: .medium))
                                .foregroundColor(.peakSuccess)
                        }
                    }
                    .symbolRenderingMode(.hierarchical)
                }
            }

            VStack(spacing: 14) {
                Text(title)
                    .font(.title.weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color.white.opacity(0.88)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)

                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.62))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 40)
        }
    }
}

#Preview {
    struct PreviewHost: View {
        @State private var done = false
        var body: some View {
            OnboardingView(hasCompletedOnboarding: $done)
        }
    }
    return PreviewHost()
}
