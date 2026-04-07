//
//  AddTrainingView.swift
//  114PeakFlow
//

import SwiftUI

struct AddTrainingView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var activity = "Running"
    @State private var duration = 45
    @State private var intensity = 3
    @State private var notes = ""
    @State private var isCompleted = false

    private let activities = ["Running", "Strength", "Climbing", "Cardio", "Hiking", "Cycling"]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .accentColor(.peakSuccess)
                        .peakFormRow()

                    Picker("Activity", selection: $activity) {
                        ForEach(activities, id: \.self) { a in
                            Text(a).tag(a)
                        }
                    }
                    .accentColor(.peakSuccess)
                    .peakFormRow()

                    HStack {
                        Text("Duration (min)")
                        Spacer()
                        TextField("", value: $duration, format: .number)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .multilineTextAlignment(.trailing)
                    }
                    .peakFormRow()

                    Stepper("Intensity: \(intensity)", value: $intensity, in: 1...5)
                        .tint(.peakSuccess)
                        .peakFormRow()
                }

                Section(header: Text("Notes").foregroundColor(.gray)) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                        .foregroundColor(.white)
                        .accentColor(.peakSuccess)
                        .peakFormRow()
                }

                Section {
                    Toggle("Completed", isOn: $isCompleted)
                        .tint(.peakSuccess)
                        .peakFormRow()
                }
            }
            .foregroundColor(.white)
            .peakFormContainer()
            .navigationTitle("New training")
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
                        let training = Training(
                            id: UUID(),
                            date: date,
                            activity: activity,
                            duration: max(duration, 1),
                            intensity: intensity,
                            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
                            isCompleted: isCompleted
                        )
                        viewModel.addTraining(training)
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
