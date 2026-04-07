//
//  TrainingView.swift
//  114PeakFlow
//

import SwiftUI

struct TrainingView: View {
    @ObservedObject var viewModel: PeakFlowViewModel
    @State private var showAddTrainingSheet = false
    @State private var weekStart: Date = TrainingView.startOfWeek(for: Date())

    var body: some View {
        NavigationStack {
            ZStack {
                PeakScreenBackground()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Training")
                        .font(.largeTitle)
                        .bold()
                        .peakScreenTitleStyle()
                        .padding(.horizontal)

                    VStack {
                        HStack {
                            Button(action: previousWeek) {
                                Image(systemName: "chevron.left")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(PeakGradients.titleShine)
                                    .frame(width: 40, height: 40)
                                    .peakElevatedSurface(cornerRadius: 12, elevation: .soft)
                            }

                            Spacer()

                            Text(weekRangeString)
                                .foregroundColor(.white)
                                .font(.headline.weight(.semibold))
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)

                            Spacer()

                            Button(action: nextWeek) {
                                Image(systemName: "chevron.right")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(PeakGradients.titleShine)
                                    .frame(width: 40, height: 40)
                                    .peakElevatedSurface(cornerRadius: 12, elevation: .soft)
                            }
                        }
                        .padding(.horizontal)

                        HStack {
                            ForEach(weekDays, id: \.self) { date in
                                VStack {
                                    Text(formattedDay(date))
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    Text(formattedDayNumber(date))
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Circle()
                                        .fill(viewModel.hasTraining(on: date) ? Color.peakSuccess : Color.clear)
                                        .frame(width: 6, height: 6)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 14)
                    .peakElevatedSurface(cornerRadius: 18, elevation: .raised)
                    .padding(.horizontal)

                    List {
                        ForEach(viewModel.todayTrainings) { training in
                            TrainingCard(training: training)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.deleteTraining(training)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }

                                    Button {
                                        viewModel.toggleTrainingCompletion(training)
                                    } label: {
                                        Label(
                                            training.isCompleted ? "Undo" : "Complete",
                                            systemImage: "checkmark"
                                        )
                                    }
                                    .tint(.peakSuccess)
                                }
                        }

                        Button {
                            showAddTrainingSheet = true
                        } label: {
                            Text("Add training")
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
            .sheet(isPresented: $showAddTrainingSheet) {
                AddTrainingView(viewModel: viewModel)
            }
        }
    }

    private var weekDays: [Date] {
        (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: weekStart) }
    }

    private var weekRangeString: String {
        guard let end = Calendar.current.date(byAdding: .day, value: 6, to: weekStart) else {
            return ""
        }
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM d"
        return "\(f.string(from: weekStart)) – \(f.string(from: end))"
    }

    private func previousWeek() {
        if let d = Calendar.current.date(byAdding: .day, value: -7, to: weekStart) {
            weekStart = d
        }
    }

    private func nextWeek() {
        if let d = Calendar.current.date(byAdding: .day, value: 7, to: weekStart) {
            weekStart = d
        }
    }

    private static func startOfWeek(for date: Date) -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: comps) ?? date
    }
}
