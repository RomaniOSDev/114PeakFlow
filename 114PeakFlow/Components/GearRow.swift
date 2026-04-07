//
//  GearRow.swift
//  114PeakFlow
//

import SwiftUI

struct GearRow: View {
    let item: Gear

    var body: some View {
        HStack {
            Image(systemName: item.isEssential ? "star.fill" : "backpack.fill")
                .foregroundColor(item.isEssential ? .peakSuccess : .gray)
                .frame(width: 30)
                .shadow(color: item.isEssential ? Color.peakSuccess.opacity(0.4) : .clear, radius: 4)

            VStack(alignment: .leading) {
                Text(item.name)
                    .foregroundColor(.white)
                    .font(.headline)

                if let weight = item.weight {
                    Text("\(Int(weight)) g")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Text("×\(item.quantity)")
                .foregroundColor(.peakSuccess)
                .bold()
        }
        .padding()
        .peakElevatedSurface(cornerRadius: 14, elevation: .soft)
        .padding(.horizontal)
    }
}
