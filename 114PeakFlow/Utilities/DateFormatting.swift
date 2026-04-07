//
//  DateFormatting.swift
//  114PeakFlow
//

import Foundation

private let uiLocale = Locale(identifier: "en_US")

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    formatter.locale = uiLocale
    return formatter.string(from: date)
}

func formattedShortDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    formatter.locale = uiLocale
    return formatter.string(from: date)
}

func formattedDay(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "E"
    formatter.locale = uiLocale
    return formatter.string(from: date)
}

func formattedDayNumber(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    formatter.locale = uiLocale
    return formatter.string(from: date)
}
