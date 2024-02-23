//
//  MainMainInteractor.swift
//  BergmannTest
//
//  Created by Nikita L on 21/02/2024.
//

import Foundation

protocol MainInteractorInput: AnyObject {
    func fetchRates()
    func saveRecord(fromRate: String, toRate: String, fromAmount: String, toAmount: String)
}

final class MainInteractor {

    private let currencyService: CurrencyService
    private let storageManager: StorageManager

    // MARK: - Properties

    weak var presenter: MainInteractorOutput?

    // MARK: - Init

    init(currencyService: CurrencyService, storageManager: StorageManager) {
        self.currencyService = currencyService
        self.storageManager = storageManager
    }
}


// MARK: - MainInteractorInput

extension MainInteractor: MainInteractorInput {
    
    func fetchRates() {
        currencyService.fetchRates { [weak self] result in
            switch result {
            case .success(let response):
                self?.presenter?.didSuccessfullyFetchRates(with: response)
                
            case .failure(let error):
                self?.presenter?.didFailureFetchRates(error: error)
            }
        }
    }

    func saveRecord(fromRate: String, toRate: String, fromAmount: String, toAmount: String) {
        storageManager.createRecord(
            fromRate: fromRate,
            toRate: toRate,
            fromAmount: fromAmount,
            toAmount: toAmount
        )
    }
}
