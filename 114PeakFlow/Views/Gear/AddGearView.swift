//
//  AddGearView.swift
//  114PeakFlow
//

import SwiftUI

struct AddGearView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var category = GearCategory.gear
    @State private var weight: Double?
    @State private var quantity = 1
    @State private var notes = ""
    @State private var isEssential = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .foregroundColor(.white)
                        .accentColor(.peakSuccess)
                        .peakFormRow()

                    Picker("Category", selection: $category) {
                        ForEach(GearCategory.all, id: \.self) { c in
                            Text(c).tag(c)
                        }
                    }
                    .accentColor(.peakSuccess)
                    .peakFormRow()

                    HStack {
                        Text("Weight (g)")
                        Spacer()
                        TextField("", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    }
                    .peakFormRow()

                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...999)
                        .tint(.peakSuccess)
                        .peakFormRow()

                    Toggle("Essential", isOn: $isEssential)
                        .tint(.peakSuccess)
                        .peakFormRow()
                }

                Section(header: Text("Notes").foregroundColor(.gray)) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 60)
                        .foregroundColor(.white)
                        .accentColor(.peakSuccess)
                        .peakFormRow()
                }
            }
            .foregroundColor(.white)
            .peakFormContainer()
            .navigationTitle("New gear")
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
                        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        let item = Gear(
                            id: UUID(),
                            name: trimmed,
                            category: category,
                            weight: weight,
                            quantity: quantity,
                            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
                            isEssential: isEssential
                        )
                        viewModel.addGear(item)
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
