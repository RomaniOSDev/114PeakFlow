//
//  AddMountainView.swift
//  114PeakFlow
//

import SwiftUI

struct AddMountainView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var mountainRange = ""
    @State private var height = 0
    @State private var country = ""
    @State private var continent = ""
    @State private var coordinates = ""
    @State private var firstAscent = ""
    @State private var descriptionText = ""
    @State private var difficulty: Difficulty = .moderate
    @State private var bestSeason = ""
    @State private var isClimbed = false
    @State private var isFavorite = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .foregroundColor(.white)
                        .accentColor(.peakSuccess)
                        .peakFormRow()
                    TextField("Range", text: $mountainRange)
                        .foregroundColor(.white)
                        .peakFormRow()
                    HStack {
                        TextField("Height (m)", value: $height, format: .number)
                            .keyboardType(.numberPad)
                    }
                    .peakFormRow()
                    TextField("Country", text: $country)
                        .foregroundColor(.white)
                        .peakFormRow()
                    TextField("Continent", text: $continent)
                        .foregroundColor(.white)
                        .peakFormRow()
                }

                Section(header: Text("Details").foregroundColor(.gray)) {
                    TextField("Coordinates (optional)", text: $coordinates)
                        .foregroundColor(.white)
                        .peakFormRow()
                    TextField("First ascent year (optional)", text: $firstAscent)
                        .foregroundColor(.white)
                        .peakFormRow()
                    TextField("Best season (optional)", text: $bestSeason)
                        .foregroundColor(.white)
                        .peakFormRow()
                    TextEditor(text: $descriptionText)
                        .frame(minHeight: 80)
                        .foregroundColor(.white)
                        .accentColor(.peakSuccess)
                        .peakFormRow()
                }

                Section {
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { d in
                            Text(d.rawValue).tag(d)
                        }
                    }
                    .accentColor(.peakSuccess)
                    .peakFormRow()

                    Toggle("Summited", isOn: $isClimbed)
                        .tint(.peakSuccess)
                        .peakFormRow()
                    Toggle("Favorite", isOn: $isFavorite)
                        .tint(.peakSuccess)
                        .peakFormRow()
                }
            }
            .foregroundColor(.white)
            .peakFormContainer()
            .navigationTitle("New mountain")
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
                        save()
                    }
                    .foregroundColor(.peakSuccess)
                    .bold()
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || height <= 0)
                }
            }
        }
        .peakNavigationChrome()
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, height > 0 else { return }

        let mountain = Mountain(
            id: UUID(),
            name: trimmedName,
            mountainRange: mountainRange.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty ?? "—",
            height: height,
            country: country.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty ?? "—",
            continent: continent.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty ?? "—",
            coordinates: coordinates.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            firstAscent: firstAscent.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            description: descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            difficulty: difficulty,
            bestSeason: bestSeason.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            isClimbed: isClimbed,
            isFavorite: isFavorite,
            createdAt: Date()
        )
        viewModel.addMountain(mountain)
        dismiss()
    }
}

private extension String {
    var nilIfEmpty: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}
