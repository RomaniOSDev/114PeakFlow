//
//  PeakFlowViewModel.swift
//  114PeakFlow
//

import Combine
import Foundation

@MainActor
final class PeakFlowViewModel: ObservableObject {
    @Published var mountains: [Mountain] = []
    @Published var ascents: [Ascent] = []
    @Published var trainings: [Training] = []
    @Published var gear: [Gear] = []
    @Published var goals: [Goal] = []
    @Published var achievements: [Achievement] = []

    @Published var selectedFilter: MountainFilter?

    enum MountainFilter {
        case climbed, goals, favorites
    }

    var climbedCount: Int {
        mountains.filter(\.isClimbed).count
    }

    var totalHeight: Int {
        mountains.filter(\.isClimbed).reduce(0) { $0 + $1.height }
    }

    var recentAscents: [Ascent] {
        Array(ascents.sorted { $0.date > $1.date }.prefix(10))
    }

    var nextGoal: Goal? {
        goals.first { !$0.isCompleted }
    }

    var incompleteGoalsCount: Int {
        goals.filter { !$0.isCompleted }.count
    }

    /// Next achievement not yet unlocked (for home teaser).
    var nextLockedAchievement: Achievement? {
        achievements.first { !$0.isAchieved }
    }

    var filteredMountains: [Mountain] {
        var result = mountains

        switch selectedFilter {
        case .climbed:
            result = result.filter(\.isClimbed)
        case .goals:
            let goalIds = goals.map(\.mountainId)
            result = result.filter { goalIds.contains($0.id) && !$0.isClimbed }
        case .favorites:
            result = result.filter(\.isFavorite)
        case nil:
            break
        }

        return result.sorted { $0.height > $1.height }
    }

    func ascentsForMountain(_ mountainId: UUID) -> [Ascent] {
        ascents.filter { $0.mountainId == mountainId }
            .sorted { $0.date > $1.date }
    }

    func lastAscent(for mountainId: UUID) -> Date? {
        ascentsForMountain(mountainId).first?.date
    }

    func hasTraining(on date: Date) -> Bool {
        trainings.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    var todayTrainings: [Training] {
        trainings.filter { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
            .sorted { $0.date < $1.date }
    }

    func addMountain(_ mountain: Mountain) {
        mountains.append(mountain)
        checkAchievements()
        saveToUserDefaults()
    }

    func updateMountain(_ mountain: Mountain) {
        if let index = mountains.firstIndex(where: { $0.id == mountain.id }) {
            mountains[index] = mountain
            saveToUserDefaults()
        }
    }

    func deleteMountain(_ mountain: Mountain) {
        mountains.removeAll { $0.id == mountain.id }
        ascents.removeAll { $0.mountainId == mountain.id }
        goals.removeAll { $0.mountainId == mountain.id }
        saveToUserDefaults()
    }

    func toggleClimbed(_ mountain: Mountain) {
        if let index = mountains.firstIndex(where: { $0.id == mountain.id }) {
            mountains[index].isClimbed.toggle()
            checkAchievements()
            saveToUserDefaults()
        }
    }

    func toggleFavoriteMountain(_ mountain: Mountain) {
        if let index = mountains.firstIndex(where: { $0.id == mountain.id }) {
            mountains[index].isFavorite.toggle()
            saveToUserDefaults()
        }
    }

    func addAscent(_ ascent: Ascent) {
        ascents.append(ascent)

        if let index = mountains.firstIndex(where: { $0.id == ascent.mountainId }) {
            mountains[index].isClimbed = true
        }

        if let goalIndex = goals.firstIndex(where: { $0.mountainId == ascent.mountainId && !$0.isCompleted }) {
            goals[goalIndex].isCompleted = true
        }

        checkAchievements()
        saveToUserDefaults()
    }

    func deleteAscent(_ ascent: Ascent) {
        ascents.removeAll { $0.id == ascent.id }
        saveToUserDefaults()
    }

    func toggleFavoriteAscent(_ ascent: Ascent) {
        if let index = ascents.firstIndex(where: { $0.id == ascent.id }) {
            ascents[index].isFavorite.toggle()
            saveToUserDefaults()
        }
    }

    func addTraining(_ training: Training) {
        trainings.append(training)
        checkAchievements()
        saveToUserDefaults()
    }

    func deleteTraining(_ training: Training) {
        trainings.removeAll { $0.id == training.id }
        saveToUserDefaults()
    }

    func toggleTrainingCompletion(_ training: Training) {
        if let index = trainings.firstIndex(where: { $0.id == training.id }) {
            trainings[index].isCompleted.toggle()
            checkAchievements()
            saveToUserDefaults()
        }
    }

    func addGear(_ item: Gear) {
        gear.append(item)
        checkAchievements()
        saveToUserDefaults()
    }

    func deleteGear(_ item: Gear) {
        gear.removeAll { $0.id == item.id }
        saveToUserDefaults()
    }

    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveToUserDefaults()
    }

    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        saveToUserDefaults()
    }

    private func checkAchievements() {
        for i in achievements.indices where !achievements[i].isAchieved {
            var achieved = false

            switch achievements[i].name {
            case AchievementTitles.firstStep:
                achieved = climbedCount >= 1
            case AchievementTitles.highAltitude:
                achieved = totalHeight >= 5000
            case AchievementTitles.alpinist:
                achieved = climbedCount >= 10
            case AchievementTitles.everest:
                achieved = totalHeight >= 8848
            case AchievementTitles.training100h:
                let totalMinutes = trainings.reduce(0) { $0 + $1.duration }
                achieved = totalMinutes >= 6000
            case AchievementTitles.gearMaster:
                achieved = gear.count >= 20
            default:
                break
            }

            if achieved {
                achievements[i].isAchieved = true
                achievements[i].achievedAt = Date()
            }
        }
        saveToUserDefaults()
    }

    private let mountainsKey = "peakflow_mountains"
    private let ascentsKey = "peakflow_ascents"
    private let trainingsKey = "peakflow_trainings"
    private let gearKey = "peakflow_gear"
    private let goalsKey = "peakflow_goals"
    private let achievementsKey = "peakflow_achievements"

    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(mountains) {
            UserDefaults.standard.set(encoded, forKey: mountainsKey)
        }
        if let encoded = try? JSONEncoder().encode(ascents) {
            UserDefaults.standard.set(encoded, forKey: ascentsKey)
        }
        if let encoded = try? JSONEncoder().encode(trainings) {
            UserDefaults.standard.set(encoded, forKey: trainingsKey)
        }
        if let encoded = try? JSONEncoder().encode(gear) {
            UserDefaults.standard.set(encoded, forKey: gearKey)
        }
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        }
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: achievementsKey)
        }
    }

    func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: mountainsKey),
           let decoded = try? JSONDecoder().decode([Mountain].self, from: data) {
            mountains = decoded
        }

        if let data = UserDefaults.standard.data(forKey: ascentsKey),
           let decoded = try? JSONDecoder().decode([Ascent].self, from: data) {
            ascents = decoded
        }

        if let data = UserDefaults.standard.data(forKey: trainingsKey),
           let decoded = try? JSONDecoder().decode([Training].self, from: data) {
            trainings = decoded
        }

        if let data = UserDefaults.standard.data(forKey: gearKey),
           let decoded = try? JSONDecoder().decode([Gear].self, from: data) {
            gear = decoded
        }

        if let data = UserDefaults.standard.data(forKey: goalsKey),
           let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
            goals = decoded
        }

        if let data = UserDefaults.standard.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        }

        if mountains.isEmpty {
            loadDemoData()
        }
    }

    private func loadDemoData() {
        let elbrus = Mountain(
            id: UUID(),
            name: "Elbrus",
            mountainRange: "Caucasus",
            height: 5642,
            country: "Russia",
            continent: "Europe",
            coordinates: "43°21′N 42°26′E",
            firstAscent: "1874",
            description: "Highest peak in Europe",
            difficulty: .hard,
            bestSeason: "July–August",
            isClimbed: true,
            isFavorite: true,
            createdAt: Date()
        )

        let kilimanjaro = Mountain(
            id: UUID(),
            name: "Kilimanjaro",
            mountainRange: "Eastern Rift",
            height: 5895,
            country: "Tanzania",
            continent: "Africa",
            coordinates: "3°04′S 37°21′E",
            firstAscent: "1889",
            description: "Highest peak in Africa",
            difficulty: .moderate,
            bestSeason: "Jan–Feb, Jul–Sep",
            isClimbed: false,
            isFavorite: true,
            createdAt: Date()
        )

        mountains = [elbrus, kilimanjaro]

        let ascent = Ascent(
            id: UUID(),
            mountainId: elbrus.id,
            mountainName: elbrus.name,
            date: Date().addingTimeInterval(-86400 * 90),
            route: .normal,
            duration: 12,
            teamMembers: ["Alex", "Maria"],
            guide: "Ivan Petrov",
            weather: .sunny,
            temperature: -10,
            altitudeSickness: false,
            equipment: ["Ice axe", "Crampons", "Rope"],
            notes: "Great climb!",
            rating: 5,
            isFavorite: true,
            createdAt: Date()
        )

        ascents = [ascent]

        let training = Training(
            id: UUID(),
            date: Date(),
            activity: "Running",
            duration: 60,
            intensity: 4,
            notes: nil,
            isCompleted: false
        )

        trainings = [training]

        let gear1 = Gear(
            id: UUID(),
            name: "Ice axe",
            category: GearCategory.gear,
            weight: 500,
            quantity: 1,
            notes: nil,
            isEssential: true
        )

        let gear2 = Gear(
            id: UUID(),
            name: "Crampons",
            category: GearCategory.footwear,
            weight: 800,
            quantity: 1,
            notes: nil,
            isEssential: true
        )

        gear = [gear1, gear2]

        let goal = Goal(
            id: UUID(),
            mountainId: kilimanjaro.id,
            mountainName: kilimanjaro.name,
            targetDate: Date().addingTimeInterval(86400 * 180),
            preparationNotes: "Train three times a week",
            isCompleted: false,
            createdAt: Date()
        )

        goals = [goal]

        achievements = [
            Achievement(
                id: UUID(),
                name: AchievementTitles.firstStep,
                description: "Summit your first peak",
                icon: "flag.fill",
                requiredValue: 1,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                name: AchievementTitles.highAltitude,
                description: "Reach 5,000 m total elevation",
                icon: "mountain.2.fill",
                requiredValue: 5000,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                name: AchievementTitles.alpinist,
                description: "Summit 10 peaks",
                icon: "crown.fill",
                requiredValue: 10,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                name: AchievementTitles.everest,
                description: "Reach 8,848 m total elevation",
                icon: "star.fill",
                requiredValue: 8848,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                name: AchievementTitles.training100h,
                description: "Log 100 hours of training",
                icon: "figure.run",
                requiredValue: 6000,
                achievedAt: nil,
                isAchieved: false
            ),
            Achievement(
                id: UUID(),
                name: AchievementTitles.gearMaster,
                description: "Add 20 gear items",
                icon: "backpack.fill",
                requiredValue: 20,
                achievedAt: nil,
                isAchieved: false
            )
        ]

        checkAchievements()
        saveToUserDefaults()
    }
}

enum GearCategory {
    static let clothing = "Clothing"
    static let footwear = "Footwear"
    static let gear = "Equipment"
    static let firstAid = "First aid"

    static let all: [String] = [clothing, footwear, gear, firstAid]
}
