//
//  AddAscentView.swift
//  114PeakFlow
//

import SwiftUI

struct AddAscentView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedMountainId: UUID?
    @State private var newMountainName = ""
    @State private var newMountainHeight = 0
    @State private var newMountainRange = ""
    @State private var date = Date()
    @State private var duration = 1
    @State private var route: RouteType = .normal
    @State private var teamMembers: [String] = [""]
    @State private var guide = ""
    @State private var weather: Weather = .sunny
    @State private var temperature: Int?
    @State private var altitudeSickness = false
    @State private var equipment: [String] = [""]
    @State private var notes = ""
    @State private var rating: Int?
    @State private var isFavorite = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Mountain", selection: $selectedMountainId) {
                        ForEach(viewModel.mountains) { mountain in
                            Text("\(mountain.name) (\(mountain.height) m)").tag(Optional(mountain.id))
                        }
                        Text("+ New mountain").tag(nil as UUID?)
                    }
                    .accentColor(.peakSuccess)
                    .peakFormRow()

                    if selectedMountainId == nil {
                        TextField("Mountain name", text: $newMountainName)
                            .foregroundColor(.white)
                            .accentColor(.peakSuccess)
                            .peakFormRow()

                        HStack {
                            TextField("Height (m)", value: $newMountainHeight, format: .number)
                                .keyboardType(.numberPad)
                                .frame(width: 100)

                            TextField("Range", text: $newMountainRange)
                        }
                        .peakFormRow()
                    }
                }

                Section {
                    DatePicker("Ascent date", selection: $date, displayedComponents: .date)
                        .accentColor(.peakSuccess)
                        .peakFormRow()

                    HStack {
                        Text("Duration (hours)")
                        Spacer()
                        TextField("", value: $duration, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .multilineTextAlignment(.trailing)
                    }
                    .peakFormRow()

                    Picker("Route", selection: $route) {
                        ForEach(RouteType.allCases, id: \.self) { r in
                            Text(r.rawValue).tag(r)
                        }
                    }
                    .accentColor(.peakSuccess)
                    .peakFormRow()
                }

                Section(header: Text("Team").foregroundColor(.gray)) {
                    ForEach($teamMembers.indices, id: \.self) { index in
                        HStack {
                            TextField("Name", text: $teamMembers[index])
                                .foregroundColor(.white)

                            Button {
                                teamMembers.remove(at: index)
                            } label: {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.peakSuccess)
                            }
                        }
                        .peakFormRow()
                    }

                    Button("Add teammate") {
                        teamMembers.append("")
                    }
                    .foregroundColor(.peakSuccess)
                    .peakFormRow()

                    TextField("Guide (optional)", text: $guide)
                        .foregroundColor(.white)
                        .accentColor(.peakSuccess)
                        .peakFormRow()
                }

                Section(header: Text("Conditions").foregroundColor(.gray)) {
                    Picker("Weather", selection: $weather) {
                        ForEach(Weather.allCases, id: \.self) { w in
                            Label(w.rawValue, systemImage: w.icon).tag(w)
                        }
                    }
                    .accentColor(.peakSuccess)
                    .peakFormRow()

                    HStack {
                        Text("Temperature (°C)")
                        Spacer()
                        TextField("", value: $temperature, format: .number)
                            .keyboardType(.numbersAndPunctuation)
                            .frame(width: 60)
                            .multilineTextAlignment(.trailing)
                    }
                    .peakFormRow()

                    Toggle("Altitude sickness", isOn: $altitudeSickness)
                        .tint(.peakSuccess)
                        .peakFormRow()
                }

                Section(header: Text("Equipment").foregroundColor(.gray)) {
                    ForEach($equipment.indices, id: \.self) { index in
                        HStack {
                            TextField("Item", text: $equipment[index])
                                .foregroundColor(.white)

                            Button {
                                equipment.remove(at: index)
                            } label: {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.peakSuccess)
                            }
                        }
                        .peakFormRow()
                    }

                    Button("Add equipment") {
                        equipment.append("")
                    }
                    .foregroundColor(.peakSuccess)
                    .peakFormRow()
                }

                Section(header: Text("Rating").foregroundColor(.gray)) {
                    Picker("Rating", selection: $rating) {
                        Text("—").tag(nil as Int?)
                        ForEach(1...5, id: \.self) { i in
                            Text(String(repeating: "★", count: i)).tag(Optional(i))
                        }
                    }
                    .pickerStyle(.segmented)
                    .peakFormRow()

                    TextEditor(text: $notes)
                        .frame(height: 80)
                        .foregroundColor(.white)
                        .accentColor(.peakSuccess)
                        .peakFormRow()
                }

                Section {
                    Toggle("Add to favorites", isOn: $isFavorite)
                        .tint(.peakSuccess)
                        .peakFormRow()
                }
            }
            .foregroundColor(.white)
            .peakFormContainer()
            .navigationTitle("New ascent")
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
                        saveAscent()
                    }
                    .foregroundColor(.peakSuccess)
                    .bold()
                }
            }
        }
        .peakNavigationChrome()
    }

    private func saveAscent() {
        let mountainId: UUID
        let mountainName: String

        if let id = selectedMountainId,
           let existing = viewModel.mountains.first(where: { $0.id == id }) {
            mountainId = id
            mountainName = existing.name
        } else {
            let trimmedName = newMountainName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty, newMountainHeight > 0 else { return }

            let range = newMountainRange.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "Unknown"
                : newMountainRange

            let newMountain = Mountain(
                id: UUID(),
                name: trimmedName,
                mountainRange: range,
                height: newMountainHeight,
                country: "—",
                continent: "—",
                coordinates: nil,
                firstAscent: nil,
                description: nil,
                difficulty: .moderate,
                bestSeason: nil,
                isClimbed: false,
                isFavorite: false,
                createdAt: Date()
            )
            viewModel.addMountain(newMountain)
            mountainId = newMountain.id
            mountainName = newMountain.name
        }

        let members = teamMembers.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let gearList = equipment.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let safeDuration = max(duration, 1)

        let ascent = Ascent(
            id: UUID(),
            mountainId: mountainId,
            mountainName: mountainName,
            date: date,
            route: route,
            duration: safeDuration,
            teamMembers: members,
            guide: guide.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            weather: weather,
            temperature: temperature,
            altitudeSickness: altitudeSickness,
            equipment: gearList,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            rating: rating,
            isFavorite: isFavorite,
            createdAt: Date()
        )

        viewModel.addAscent(ascent)
        dismiss()
    }
}

private extension String {
    var nilIfEmpty: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}
