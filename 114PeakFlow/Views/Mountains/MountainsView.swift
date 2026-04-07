//
//  MountainsView.swift
//  114PeakFlow
//

import SwiftUI

struct MountainsView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    @State private var path = NavigationPath()
    @State private var showAddMountainSheet = false

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                PeakScreenBackground()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Mountains")
                        .font(.largeTitle)
                        .bold()
                        .peakScreenTitleStyle()
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            FilterChip(title: "All", isSelected: viewModel.selectedFilter == nil, color: .peakSuccess) {
                                viewModel.selectedFilter = nil
                            }
                            FilterChip(title: "Summited", isSelected: viewModel.selectedFilter == .climbed, color: .peakSuccess) {
                                viewModel.selectedFilter = .climbed
                            }
                            FilterChip(title: "Goals", isSelected: viewModel.selectedFilter == .goals, color: .peakSuccess) {
                                viewModel.selectedFilter = .goals
                            }
                            FilterChip(title: "Favorites", isSelected: viewModel.selectedFilter == .favorites, color: .peakSuccess) {
                                viewModel.selectedFilter = .favorites
                            }
                        }
                        .padding(.horizontal)
                    }

                    List {
                        ForEach(viewModel.filteredMountains) { mountain in
                            MountainCard(
                                mountain: mountain,
                                lastAscentDate: viewModel.lastAscent(for: mountain.id)
                            )
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                path.append(mountain.id)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.deleteMountain(mountain)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }

                                Button {
                                    viewModel.toggleClimbed(mountain)
                                } label: {
                                    Label(
                                        mountain.isClimbed ? "Mark not summited" : "Mark summited",
                                        systemImage: "flag"
                                    )
                                }
                                .tint(.peakSuccess)

                                Button {
                                    viewModel.toggleFavoriteMountain(mountain)
                                } label: {
                                    Label("Favorite", systemImage: "star")
                                }
                                .tint(.peakSuccess)
                            }
                        }

                        Button {
                            showAddMountainSheet = true
                        } label: {
                            Text("Add mountain")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(PeakGradients.titleShine)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .peakElevatedSurface(cornerRadius: 16, elevation: .raised)
                        }
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: UUID.self) { id in
                MountainDetailView(viewModel: viewModel, mountainId: id)
            }
            .sheet(isPresented: $showAddMountainSheet) {
                AddMountainView(viewModel: viewModel)
            }
        }
    }
}
