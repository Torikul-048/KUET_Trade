//
//  ExchangeRateResponse.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation

struct ExchangeRateResponse: Codable {
    let result: String
    let rates: [String: Double]
}
