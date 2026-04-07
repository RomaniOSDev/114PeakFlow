//
//  PeakExternalLink.swift
//  114PeakFlow
//

import Foundation

enum PeakExternalLink: String {
    case privacyPolicy = "https://www.termsfeed.com/live/19adebe9-57cc-410e-a0c3-a920ff5b7a82"
    case termsOfUse = "https://www.termsfeed.com/live/f1acb51d-8ea4-4d2e-8832-6a8e6c27d5dd"

    var url: URL? {
        URL(string: rawValue)
    }
}
