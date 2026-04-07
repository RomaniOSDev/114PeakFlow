//
//  AscentCard.swift
//  114PeakFlow
//

import SwiftUI

struct AscentCard: View {
    let ascent: Ascent

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "flag.fill")
                    .foregroundColor(.peakSuccess)
                    .font(.title2)
                    .shadow(color: Color.peakSuccess.opacity(0.45), radius: 6)

                VStack(alignment: .leading) {
                    Text(ascent.mountainName)
                        .foregroundColor(.white)
                        .font(.headline)

                    Text(formattedDate(ascent.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                Text("\(ascent.duration) h")
                    .foregroundColor(.peakSuccess)
                    .font(.title3)
                    .bold()

                if ascent.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.peakSuccess)
                        .font(.caption)
                        .shadow(color: Color.peakSuccess.opacity(0.5), radius: 4)
                }
            }

            HStack {
                Image(systemName: ascent.route.icon)
                    .font(.caption)
                    .foregroundColor(.peakSuccess)

                Text(ascent.route.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Image(systemName: ascent.weather.icon)
                    .font(.caption)
                    .foregroundColor(.peakSuccess)

                Text(ascent.weather.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            if let rating = ascent.rating {
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { i in
                        Image(systemName: i <= rating ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundColor(.peakSuccess)
                    }
                }
            }

            if !ascent.teamMembers.isEmpty {
                HStack {
                    Image(systemName: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(.peakSuccess)

                    Text(ascent.teamMembers.joined(separator: ", "))
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .peakElevatedSurface(cornerRadius: 16, elevation: .card)
    }
}
