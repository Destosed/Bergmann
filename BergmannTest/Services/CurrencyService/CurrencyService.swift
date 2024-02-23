//
//  CurrencyService.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 23.02.2024.
//

import Foundation

protocol CurrencyService {
    func fetchRates(completion: @escaping ((Result<RatesResponse, Error>) -> Void))
}
