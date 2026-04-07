//
//  PeakVisualStyle.swift
//  114PeakFlow
//

import SwiftUI
import UIKit

enum PeakChrome {
    static func applyTabBarStyle() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.035, green: 0.059, blue: 0.118, alpha: 0.96)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.35)
        appearance.shadowImage = UIImage()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Gradients

enum PeakGradients {
    static var cardFill: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.15, green: 0.20, blue: 0.34),
                Color.peakCard,
                Color(red: 0.06, green: 0.09, blue: 0.16)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var edgeHighlight: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.20),
                Color.white.opacity(0.06),
                Color.peakSuccess.opacity(0.18)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var heroPanel: LinearGradient {
        LinearGradient(
            colors: [
                Color.peakSuccess.opacity(0.28),
                Color(red: 0.12, green: 0.16, blue: 0.30),
                Color.peakCard.opacity(0.95)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var titleShine: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.45, green: 0.88, blue: 1.0),
                Color.peakSuccess,
                Color.peakSuccess.opacity(0.72)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var accentButton: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.15, green: 0.72, blue: 1.0),
                Color.peakSuccess,
                Color(red: 0.0, green: 0.48, blue: 0.82)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var chipUnselected: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.13, green: 0.17, blue: 0.30),
                Color.peakCard
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var chipSelected: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.2, green: 0.75, blue: 1.0),
                Color.peakSuccess,
                Color(red: 0.0, green: 0.52, blue: 0.9)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Screen backdrop

struct PeakScreenBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.085, blue: 0.165),
                    Color.peakBackground,
                    Color(red: 0.018, green: 0.032, blue: 0.075)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [
                    Color.peakSuccess.opacity(0.16),
                    Color.peakSuccess.opacity(0.05),
                    Color.clear
                ],
                center: .top,
                startRadius: 30,
                endRadius: 360
            )

            RadialGradient(
                colors: [
                    Color.peakSuccess.opacity(0.06),
                    Color.clear
                ],
                center: UnitPoint(x: 0.85, y: 0.35),
                startRadius: 20,
                endRadius: 200
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - Elevation

enum PeakElevation {
    case soft
    case card
    case raised
    case floating
}

struct PeakElevatedSurfaceModifier: ViewModifier {
    var cornerRadius: CGFloat
    var elevation: PeakElevation

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        let (blackOpacity, radius, y, glowOpacity, glowRadius): (Double, CGFloat, CGFloat, Double, CGFloat) = {
            switch elevation {
            case .soft:
                return (0.28, 6, 3, 0.05, 8)
            case .card:
                return (0.45, 12, 6, 0.08, 14)
            case .raised:
                return (0.52, 18, 9, 0.12, 20)
            case .floating:
                return (0.58, 24, 12, 0.28, 28)
            }
        }()

        return content
            .background(
                shape
                    .fill(PeakGradients.cardFill)
            )
            .overlay(
                shape
                    .strokeBorder(PeakGradients.edgeHighlight, lineWidth: 1)
            )
            .shadow(color: .black.opacity(blackOpacity), radius: radius, x: 0, y: y)
            .shadow(color: Color.peakSuccess.opacity(glowOpacity), radius: glowRadius, x: 0, y: y * 0.5)
    }
}

extension View {
    func peakElevatedSurface(cornerRadius: CGFloat = 16, elevation: PeakElevation = .card) -> some View {
        modifier(PeakElevatedSurfaceModifier(cornerRadius: cornerRadius, elevation: elevation))
    }

    /// Large tab titles (Mountains, Training, …)
    func peakScreenTitleStyle() -> some View {
        self
            .foregroundStyle(PeakGradients.titleShine)
            .shadow(color: Color.peakSuccess.opacity(0.38), radius: 12, x: 0, y: 3)
    }

    func peakCapsuleCTA() -> some View {
        self
            .background(
                Capsule()
                    .fill(PeakGradients.accentButton)
                    .overlay(
                        Capsule()
                            .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.35), radius: 8, x: 0, y: 5)
            .shadow(color: Color.peakSuccess.opacity(0.35), radius: 14, x: 0, y: 4)
    }
}
