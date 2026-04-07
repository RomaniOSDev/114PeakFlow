//
//  GearView.swift
//  114PeakFlow
//

import SwiftUI

struct GearView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    @State private var showAddGearSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                PeakScreenBackground()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Gear")
                        .font(.largeTitle)
                        .bold()
                        .peakScreenTitleStyle()
                        .padding(.horizontal)

                    List {
                        ForEach(GearCategory.all, id: \.self) { category in
                            let items = viewModel.gear.filter { $0.category == category }
                            if !items.isEmpty {
                                Section {
                                    ForEach(items) { item in
                                        GearRow(item: item)
                                            .listRowInsets(EdgeInsets())
                                            .listRowBackground(Color.peakBackground)
                                            .listRowSeparatorTint(Color.white.opacity(0.12))
                                            .swipeActions(edge: .trailing) {
                                                Button(role: .destructive) {
                                                    viewModel.deleteGear(item)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                    }
                                } header: {
                                    Text(category)
                                        .font(.headline.weight(.semibold))
                                        .foregroundStyle(PeakGradients.titleShine)
                                        .shadow(color: Color.peakSuccess.opacity(0.25), radius: 6, x: 0, y: 1)
                                        .textCase(nil)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 6)
                                        .background(Color.clear)
                                }
                            }
                        }

                        Button {
                            showAddGearSheet = true
                        } label: {
                            Text("Add gear")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(PeakGradients.titleShine)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .peakElevatedSurface(cornerRadius: 16, elevation: .raised)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.peakBackground)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .listRowSeparatorTint(Color.white.opacity(0.12))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showAddGearSheet) {
                AddGearView(viewModel: viewModel)
            }
        }
    }
}
