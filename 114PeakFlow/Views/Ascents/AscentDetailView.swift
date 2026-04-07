//
//  AscentDetailView.swift
//  114PeakFlow
//

import SwiftUI

struct AscentDetailView: View {
    let ascent: Ascent
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                PeakScreenBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AscentCard(ascent: ascent)

                        if let guide = ascent.guide, !guide.isEmpty {
                            detailRow(title: "Guide", value: guide)
                        }

                        if let temp = ascent.temperature {
                            detailRow(title: "Temperature", value: "\(temp) °C")
                        }

                        HStack {
                            Text("Altitude sickness")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(ascent.altitudeSickness ? "Yes" : "No")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .peakElevatedSurface(cornerRadius: 14, elevation: .soft)

                        if !ascent.equipment.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Equipment")
                                    .font(.headline)
                                    .foregroundStyle(PeakGradients.titleShine)
                                Text(ascent.equipment.joined(separator: ", "))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .peakElevatedSurface(cornerRadius: 16, elevation: .card)
                        }

                        if let notes = ascent.notes, !notes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.headline)
                                    .foregroundStyle(PeakGradients.titleShine)
                                Text(notes)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .peakElevatedSurface(cornerRadius: 16, elevation: .card)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Ascent")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.peakSuccess)
                }
            }
        }
        .peakNavigationChrome()
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
        .padding()
        .peakElevatedSurface(cornerRadius: 14, elevation: .soft)
    }
}
