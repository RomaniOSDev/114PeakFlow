//
//  PeakModels.swift
//  114PeakFlow
//

import SwiftUI

enum Difficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case moderate = "Moderate"
    case hard = "Hard"
    case expert = "Expert"
    case extreme = "Extreme"

    var icon: String {
        switch self {
        case .easy: return "1.circle"
        case .moderate: return "2.circle"
        case .hard: return "3.circle"
        case .expert: return "4.circle"
        case .extreme: return "5.circle"
        }
    }

    var color: Color {
        switch self {
        case .easy: return .peakSuccess.opacity(0.5)
        case .moderate: return .peakSuccess.opacity(0.7)
        case .hard: return .peakSuccess
        case .expert: return .peakSuccess
        case .extreme: return .peakSuccess
        }
    }
}

enum RouteType: String, CaseIterable, Codable {
    case normal = "Classic route"
    case technical = "Technical"
    case ice = "Ice"
    case rock = "Rock"
    case mixed = "Mixed"
    case ski = "Ski touring"

    var icon: String {
        switch self {
        case .normal: return "map.fill"
        case .technical: return "gear"
        case .ice: return "snowflake"
        case .rock: return "mountain.2.fill"
        case .mixed: return "arrow.triangle.2.circlepath"
        case .ski: return "figure.skiing.downhill"
        }
    }
}

enum Weather: String, CaseIterable, Codable {
    case sunny = "Sunny"
    case partlyCloudy = "Partly cloudy"
    case cloudy = "Cloudy"
    case rain = "Rain"
    case snow = "Snow"
    case storm = "Storm"
    case fog = "Fog"

    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .rain: return "cloud.rain.fill"
        case .snow: return "cloud.snow.fill"
        case .storm: return "cloud.bolt.fill"
        case .fog: return "cloud.fog.fill"
        }
    }
}

struct Mountain: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var mountainRange: String
    var height: Int
    var country: String
    var continent: String
    var coordinates: String?
    var firstAscent: String?
    var description: String?
    var difficulty: Difficulty
    var bestSeason: String?
    var isClimbed: Bool
    var isFavorite: Bool
    let createdAt: Date

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Mountain, rhs: Mountain) -> Bool {
        lhs.id == rhs.id
    }
}

struct Ascent: Identifiable, Codable {
    let id: UUID
    let mountainId: UUID
    var mountainName: String
    var date: Date
    var route: RouteType
    var duration: Int
    var teamMembers: [String]
    var guide: String?
    var weather: Weather
    var temperature: Int?
    var altitudeSickness: Bool
    var equipment: [String]
    var notes: String?
    var rating: Int?
    var isFavorite: Bool
    let createdAt: Date
}

struct Gear: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var weight: Double?
    var quantity: Int
    var notes: String?
    var isEssential: Bool
}

struct Training: Identifiable, Codable {
    let id: UUID
    var date: Date
    var activity: String
    var duration: Int
    var intensity: Int
    var notes: String?
    var isCompleted: Bool
}

struct Goal: Identifiable, Codable {
    let id: UUID
    var mountainId: UUID
    var mountainName: String
    var targetDate: Date?
    var preparationNotes: String?
    var isCompleted: Bool
    let createdAt: Date
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var icon: String
    var requiredValue: Int
    var achievedAt: Date?
    var isAchieved: Bool
}

enum AchievementTitles {
    static let firstStep = "First Step"
    static let highAltitude = "High Altitude"
    static let alpinist = "Alpinist"
    static let everest = "Everest"
    static let training100h = "100 Training Hours"
    static let gearMaster = "Gear Master"
}
