//
//  CurrencyViewModel.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation

@MainActor
final class CurrencyViewModel: ObservableObject {
    @Published var convertedUSD: Double?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?

    func loadUSDValue(for amountBDT: Double) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let rate = try await CurrencyService.shared.getExchangeRate(from: "BDT", to: "USD")
            convertedUSD = amountBDT * rate
        } catch {
            convertedUSD = nil
            errorMessage = "Failed to fetch exchange rate: \(error.localizedDescription)"
            showError = true
        }
    }

    var formattedUSD: String? {
        guard let convertedUSD else { return nil }
        return String(format: "$%.2f", convertedUSD)
    }
}
