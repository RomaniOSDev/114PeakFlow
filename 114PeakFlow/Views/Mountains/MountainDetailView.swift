//
//  MountainDetailView.swift
//  114PeakFlow
//

import SwiftUI

struct MountainDetailView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    let mountainId: UUID

    @State private var showAddGoal = false

    private var mountain: Mountain? {
        viewModel.mountains.first { $0.id == mountainId }
    }

    private var hasActiveGoal: Bool {
        viewModel.goals.contains { $0.mountainId == mountainId && !$0.isCompleted }
    }

    var body: some View {
        ZStack {
            PeakScreenBackground()

            Group {
                if let mountain {
                    content(for: mountain)
                } else {
                    Text("Mountain not found")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddGoal) {
            if let mountain {
                AddGoalView(viewModel: viewModel, mountain: mountain)
            }
        }
    }

    @ViewBuilder
    private func content(for mountain: Mountain) -> some View {
        ScrollView {
            VStack(alignment: .center, spacing: 12) {
                Text(mountain.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color.white.opacity(0.88)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.35), radius: 3, x: 0, y: 2)
                    .multilineTextAlignment(.center)

                Text("\(mountain.height) m")
                    .font(.title2)
                    .foregroundStyle(PeakGradients.titleShine)
                    .shadow(color: Color.peakSuccess.opacity(0.35), radius: 8, x: 0, y: 2)

                Text("\(mountain.mountainRange), \(mountain.country)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack {
                    Image(systemName: mountain.difficulty.icon)
                        .foregroundColor(mountain.difficulty.color)
                    Text(mountain.difficulty.rawValue)
                        .foregroundColor(mountain.difficulty.color)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    mountain.difficulty.color.opacity(0.38),
                                    mountain.difficulty.color.opacity(0.12)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(mountain.difficulty.color.opacity(0.5), lineWidth: 1)
                        )
                )
                .shadow(color: mountain.difficulty.color.opacity(0.25), radius: 8, x: 0, y: 4)

                if !mountain.isClimbed, !hasActiveGoal {
                    Button {
                        showAddGoal = true
                    } label: {
                        Text("Set as goal")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(Color.peakBackground)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 12)
                            .peakCapsuleCTA()
                    }
                    .padding(.top, 6)
                }
            }
            .padding(22)
            .peakElevatedSurface(cornerRadius: 22, elevation: .raised)
            .padding(.horizontal)
            .padding(.top, 8)

            if let description = mountain.description {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                        .foregroundStyle(PeakGradients.titleShine)

                    Text(description)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .peakElevatedSurface(cornerRadius: 16, elevation: .card)
                }
                .padding(.horizontal)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Ascents")
                    .font(.headline)
                    .foregroundStyle(PeakGradients.titleShine)

                let ascents = viewModel.ascentsForMountain(mountain.id)

                if ascents.isEmpty {
                    Text("No ascent records yet")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .peakElevatedSurface(cornerRadius: 14, elevation: .soft)
                } else {
                    ForEach(ascents) { ascent in
                        HStack {
                            Image(systemName: ascent.route.icon)
                                .foregroundColor(.peakSuccess)
                                .shadow(color: Color.peakSuccess.opacity(0.35), radius: 4)

                            VStack(alignment: .leading) {
                                Text(formattedDate(ascent.date))
                                    .foregroundColor(.white)
                                    .font(.headline)

                                Text(ascent.route.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Text("\(ascent.duration) h")
                                .foregroundColor(.peakSuccess)
                                .bold()
                        }
                        .padding()
                        .peakElevatedSurface(cornerRadius: 14, elevation: .card)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 28)
        }
    }
}

struct AddGoalView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    let mountain: Mountain
    @Environment(\.dismiss) private var dismiss

    @State private var targetDate = Date().addingTimeInterval(86400 * 30)
    @State private var hasTargetDate = true
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(mountain.name)
                        .foregroundColor(.white)
                        .peakFormRow()
                    Toggle("Target date", isOn: $hasTargetDate)
                        .tint(.peakSuccess)
                        .peakFormRow()
                    if hasTargetDate {
                        DatePicker("Date", selection: $targetDate, displayedComponents: .date)
                            .accentColor(.peakSuccess)
                            .peakFormRow()
                    }
                }
                Section(header: Text("Preparation").foregroundColor(.gray)) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .foregroundColor(.white)
                        .accentColor(.peakSuccess)
                        .peakFormRow()
                }
            }
            .foregroundColor(.white)
            .peakFormContainer()
            .navigationTitle("New goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.peakSuccess)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let goal = Goal(
                            id: UUID(),
                            mountainId: mountain.id,
                            mountainName: mountain.name,
                            targetDate: hasTargetDate ? targetDate : nil,
                            preparationNotes: notes.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
                            isCompleted: false,
                            createdAt: Date()
                        )
                        viewModel.addGoal(goal)
                        dismiss()
                    }
                    .foregroundColor(.peakSuccess)
                    .bold()
                }
            }
        }
        .peakNavigationChrome()
    }
}

private extension String {
    var nilIfEmpty: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}
