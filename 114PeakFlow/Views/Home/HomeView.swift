//
//  HomeView.swift
//  114PeakFlow
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    @Binding var selectedTab: Int

    @State private var showAddAscent = false
    @State private var selectedAscent: Ascent?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                PeakScreenBackground()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        heroHeader
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 20)

                        statsSection
                            .padding(.bottom, 20)

                        quickActionsRow
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)

                        if let goal = viewModel.nextGoal {
                            nextGoalSection(goal: goal)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                        }

                        if !viewModel.todayTrainings.isEmpty {
                            todayTrainingSection
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                        }

                        achievementsStrip
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)

                        recentAscentsSection
                            .padding(.bottom, 100)
                    }
                }

                addAscentFAB
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showAddAscent) {
                AddAscentView(viewModel: viewModel)
            }
            .sheet(item: $selectedAscent) { ascent in
                AscentDetailView(ascent: ascent)
            }
        }
    }

    // MARK: - Hero

    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(PeakGradients.heroPanel)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(PeakGradients.edgeHighlight, lineWidth: 1)
                )
                .overlay(
                    LinearGradient(
                        colors: [Color.white.opacity(0.08), Color.clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                )
                .shadow(color: .black.opacity(0.45), radius: 18, x: 0, y: 10)
                .shadow(color: Color.peakSuccess.opacity(0.15), radius: 24, x: 0, y: 8)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.peakSuccess.opacity(0.22))
                            .frame(width: 44, height: 44)
                            .shadow(color: Color.peakSuccess.opacity(0.35), radius: 8)
                        Image(systemName: "mountain.2.fill")
                            .font(.title2)
                            .foregroundStyle(PeakGradients.titleShine)
                    }
                    Spacer()
                    Text(todayFormatted)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.white.opacity(0.75))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.25))
                                .overlay(Capsule().strokeBorder(Color.white.opacity(0.12), lineWidth: 1))
                        )
                }

                Text(timeGreeting)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color.white.opacity(0.88)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.35), radius: 2, x: 0, y: 1)

                Text("Log ascents, plan summits, stay ready.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.65))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
    }

    private var timeGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }

    private var todayFormatted: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEE, MMM d"
        return f.string(from: Date())
    }

    // MARK: - Stats

    private var statsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                HomeStatTile(
                    title: "Summited",
                    value: "\(viewModel.climbedCount)",
                    icon: "flag.fill"
                )
                HomeStatTile(
                    title: "Elevation",
                    value: formatElevation(viewModel.totalHeight),
                    icon: "arrow.up.right"
                )
                HomeStatTile(
                    title: "Ascents",
                    value: "\(viewModel.ascents.count)",
                    icon: "figure.hiking"
                )
                HomeStatTile(
                    title: "Goals left",
                    value: "\(viewModel.incompleteGoalsCount)",
                    icon: "target"
                )
            }
            .padding(.horizontal, 20)
        }
    }

    private func formatElevation(_ meters: Int) -> String {
        if meters >= 1000 {
            let km = Double(meters) / 1000.0
            return String(format: "%.1f km", km)
        }
        return "\(meters) m"
    }

    // MARK: - Quick actions

    private var quickActionsRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Shortcuts")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white.opacity(0.8))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    HomeShortcutChip(title: "Mountains", icon: "mountain.2.fill") {
                        selectedTab = 1
                    }
                    HomeShortcutChip(title: "Training", icon: "figure.run") {
                        selectedTab = 2
                    }
                    HomeShortcutChip(title: "Gear", icon: "backpack.fill") {
                        selectedTab = 3
                    }
                    HomeShortcutChip(title: "Achievements", icon: "trophy.fill") {
                        selectedTab = 4
                    }
                }
            }
        }
    }

    // MARK: - Next goal

    private func nextGoalSection(goal: Goal) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Next goal")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Button {
                    selectedTab = 1
                } label: {
                    Text("Open")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.peakSuccess)
                }
            }

            Button {
                selectedTab = 1
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.peakSuccess.opacity(0.2))
                            .frame(width: 48, height: 48)
                        Image(systemName: "scope")
                            .font(.title3)
                            .foregroundColor(.peakSuccess)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(goal.mountainName)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        if let date = goal.targetDate {
                            Text("Target: \(formattedShortDate(date))")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.55))
                        } else {
                            Text("No target date")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.55))
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white.opacity(0.35))
                }
                .padding(16)
                .peakElevatedSurface(cornerRadius: 18, elevation: .raised)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Today’s training

    private var todayTrainingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today’s training")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Button {
                    selectedTab = 2
                } label: {
                    Text("View all")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.peakSuccess)
                }
            }

            VStack(spacing: 10) {
                ForEach(viewModel.todayTrainings.prefix(3)) { training in
                    HStack {
                        Image(systemName: training.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(training.isCompleted ? .peakSuccess : .white.opacity(0.35))
                            .font(.title3)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(training.activity)
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(.white)
                                .strikethrough(training.isCompleted)
                            Text("\(training.duration) min · intensity \(training.intensity)/5")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button {
                            viewModel.toggleTrainingCompletion(training)
                        } label: {
                            Text(training.isCompleted ? "Undo" : "Done")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.peakSuccess)
                        }
                    }
                    .padding(14)
                    .peakElevatedSurface(cornerRadius: 16, elevation: .card)
                }
            }
        }
    }

    // MARK: - Achievements

    private var achievementsStrip: some View {
        let unlocked = viewModel.achievements.filter(\.isAchieved).count
        let total = viewModel.achievements.count

        return Button {
            selectedTab = 4
        } label: {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.peakSuccess.opacity(0.18))
                        .frame(width: 44, height: 44)
                    Image(systemName: "star.fill")
                        .foregroundColor(.peakSuccess)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Achievements")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                    Text("\(unlocked) of \(total) unlocked")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                if let next = viewModel.nextLockedAchievement {
                    Text(next.name)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                        .frame(maxWidth: 120, alignment: .trailing)
                }

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white.opacity(0.35))
            }
            .padding(16)
            .peakElevatedSurface(cornerRadius: 18, elevation: .card)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Recent ascents

    private var recentAscentsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Recent ascents")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                if !viewModel.recentAscents.isEmpty {
                    Text("\(viewModel.recentAscents.count) shown")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)

            if viewModel.recentAscents.isEmpty {
                emptyAscentsPlaceholder
                    .padding(.horizontal, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.recentAscents) { ascent in
                        AscentCard(ascent: ascent)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedAscent = ascent
                            }
                            .contextMenu {
                                Button {
                                    viewModel.toggleFavoriteAscent(ascent)
                                } label: {
                                    Label(
                                        ascent.isFavorite ? "Remove favorite" : "Favorite",
                                        systemImage: "star"
                                    )
                                }
                                Button(role: .destructive) {
                                    viewModel.deleteAscent(ascent)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }

    private var emptyAscentsPlaceholder: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.hiking")
                .font(.system(size: 40))
                .foregroundStyle(Color.peakSuccess.opacity(0.6))

            Text("No ascents yet")
                .font(.headline)
                .foregroundColor(.white)

            Text("Tap + to log your first climb.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Button {
                showAddAscent = true
            } label: {
                Text("Log ascent")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color.peakBackground)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .peakCapsuleCTA()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .padding(.horizontal, 20)
        .peakElevatedSurface(cornerRadius: 20, elevation: .raised)
    }

    // MARK: - FAB

    private var addAscentFAB: some View {
        Button {
            showAddAscent = true
        } label: {
            ZStack {
                Circle()
                    .fill(PeakGradients.accentButton)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.45), radius: 14, x: 0, y: 8)
                    .shadow(color: Color.peakSuccess.opacity(0.5), radius: 20, x: 0, y: 6)
                Image(systemName: "plus")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
            }
        }
        .padding(20)
        .accessibilityLabel("Add ascent")
    }
}

// MARK: - Home subviews

private struct HomeStatTile: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.peakSuccess.opacity(0.28), Color.peakSuccess.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 38, height: 38)
                    .overlay(
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .strokeBorder(Color.peakSuccess.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: Color.peakSuccess.opacity(0.25), radius: 6, x: 0, y: 3)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(PeakGradients.titleShine)
            }

            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)

            Text(value)
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(14)
        .frame(width: 132, alignment: .leading)
        .peakElevatedSurface(cornerRadius: 17, elevation: .card)
    }
}

private struct HomeShortcutChip: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.semibold))
                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .foregroundStyle(PeakGradients.titleShine)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(PeakGradients.chipUnselected)
                    .overlay(
                        Capsule()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color.peakSuccess.opacity(0.45), Color.white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: .black.opacity(0.35), radius: 8, x: 0, y: 4)
            .shadow(color: Color.peakSuccess.opacity(0.12), radius: 10, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}
