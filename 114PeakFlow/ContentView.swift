//
//  ContentView.swift
//  114PeakFlow
//


import SwiftUI

struct ContentView: View {
    @AppStorage("peakflow_onboarding_complete") private var onboardingComplete = false
    @StateObject private var viewModel = PeakFlowViewModel()
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if onboardingComplete {
                mainTabInterface
            } else {
                OnboardingView(hasCompletedOnboarding: $onboardingComplete)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var mainTabInterface: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            MountainsView(viewModel: viewModel)
                .tabItem {
                    Label("Mountains", systemImage: "mountain.2.fill")
                }
                .tag(1)

            TrainingView(viewModel: viewModel)
                .tabItem {
                    Label("Training", systemImage: "figure.run")
                }
                .tag(2)

            GearView(viewModel: viewModel)
                .tabItem {
                    Label("Gear", systemImage: "backpack.fill")
                }
                .tag(3)

            AchievementsView(viewModel: viewModel)
                .tabItem {
                    Label("Achievements", systemImage: "trophy.fill")
                }
                .tag(4)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(5)
        }
        .onAppear {
            PeakChrome.applyTabBarStyle()
            viewModel.loadFromUserDefaults()
        }
        .tint(.peakSuccess)
    }
}

#Preview {
    ContentView()
}
