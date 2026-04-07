//
//  View+PeakForm.swift
//  114PeakFlow
//

import SwiftUI

extension View {
    /// Dark grouped look for `Form` / `List` rows (peakCard) on peakBackground.
    func peakFormRow() -> some View {
        listRowBackground(Color.peakCard)
            .listRowSeparatorTint(Color.white.opacity(0.12))
    }

    func peakFormContainer() -> some View {
        scrollContentBackground(.hidden)
            .background(Color.peakBackground)
    }

    func peakNavigationChrome() -> some View {
        toolbarBackground(Color.peakBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}
