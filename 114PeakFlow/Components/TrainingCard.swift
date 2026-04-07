//
//  TrainingCard.swift
//  114PeakFlow
//

import SwiftUI

struct TrainingCard: View {
    let training: Training

    var body: some View {
        HStack {
            Image(systemName: training.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(training.isCompleted ? .peakSuccess : .gray)
                .font(.title2)
                .shadow(color: training.isCompleted ? Color.peakSuccess.opacity(0.4) : .clear, radius: 5)

            VStack(alignment: .leading) {
                Text(training.activity)
                    .foregroundColor(training.isCompleted ? .gray : .white)
                    .font(.headline)
                    .strikethrough(training.isCompleted)

                Text("\(training.duration) min")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: i <= training.intensity ? "bolt.fill" : "bolt")
                        .font(.caption)
                        .foregroundColor(i <= training.intensity ? .peakSuccess : .gray)
                }
            }
        }
        .padding()
        .peakElevatedSurface(cornerRadius: 16, elevation: .card)
    }
}
