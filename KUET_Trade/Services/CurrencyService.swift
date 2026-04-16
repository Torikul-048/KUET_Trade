//
//  CurrencyService.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation

final class CurrencyService {
    static let shared = CurrencyService()

    private init() {}

    func getExchangeRate(from: String = "BDT", to: String = "USD") async throws -> Double {
        let base = from.uppercased()
        let target = to.uppercased()

        guard let url = URL(string: "\(AppConstants.Currency.baseURL)/\(base)") else {
            throw CurrencyError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw CurrencyError.requestFailed
        }

        let decoded = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)

        guard decoded.result.lowercased() == "success" else {
            throw CurrencyError.invalidResponse
        }

        guard let rate = decoded.rates[target] else {
            throw CurrencyError.rateNotFound
        }

        return rate
    }
}

enum CurrencyError: LocalizedError {
    case invalidURL
    case requestFailed
    case invalidResponse
    case rateNotFound

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid currency API URL."
        case .requestFailed:
            return "Currency request failed."
        case .invalidResponse:
            return "Currency response was invalid."
        case .rateNotFound:
            return "Exchange rate not found."
        }
    }
}
