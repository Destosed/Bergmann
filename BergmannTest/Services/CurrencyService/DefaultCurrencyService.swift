//
//  DefaultCurrencyService.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 21.02.2024.
//

import Foundation

struct RatesResponse: Decodable {
    let data: [String: Double]
}

final class DefaultCurrencyService {

    // MARK: - Type Properties

    static let shared: CurrencyService = DefaultCurrencyService()
    
    // MARK: - Private Properties
    
    private let baseURL = "https://api.freecurrencyapi.com/v1/latest"
    private let key = "fca_live_8P5N3JRUNBtg5vndhOW4ckmTRmAhKwLuzN1BU7Np"
    
    private let apiClient = DefaultAPICLient()

    // MARK: - Init

    private init() { }
}

extension DefaultCurrencyService: CurrencyService {
    
    func fetchRates(completion: @escaping ((Result<RatesResponse, Error>) -> Void)) {
        var urlComponents = URLComponents(string: baseURL)

        urlComponents?.queryItems = [
            .init(name: "apikey", value: key),
            .init(name: "currencies", value: "RUB,USD,EUR,GBP,CHF,CNY")
        ]

        guard let url = urlComponents?.url else {
            return
        }

        let request = URLRequest(url: url)

        apiClient.fetchDecodable(request: request, completion: completion)
    }
}
