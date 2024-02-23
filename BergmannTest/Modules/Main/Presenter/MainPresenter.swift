//
//  MainMainPresenter.swift
//  BergmannTest
//
//  Created by Nikita L on 21/02/2024.
//

import Foundation

protocol MainModuleOutput: AnyObject { }

protocol MainInteractorOutput: AnyObject {
    func didSuccessfullyFetchRates(with response: RatesResponse)
    func didFailureFetchRates(error: Error)
}

protocol MainViewOutput: ViewOutput {
    func didTapRateView(with type: RateViewType)
    func didTapArchiveButton()
    func textFieldDidUpdate(string: String?)
    func didTapRefresh()
    func didTapSwapButton()
    func didEndEditting()
}

final class MainPresenter {


    // MARK: - Public Properties

    weak var view: MainViewInput?
    var interactor: MainInteractorInput?
    var router: MainRouterInput?

    // MARK: - Private Properties

    private let userDefaultsManager: UserDefaultsManager

    private var lastUpdateDate = Date()

    private let rates: [String]
    private var fromRate = String()
    private var toRate = String()

    private var fromAmount: Double = 0
    private var toAmount: Double = 0

    private var ratesResponse: RatesResponse?

    // MARK: - Init
    
    init(supportedRates: [String], userDefaultsManager: UserDefaultsManager) {
        self.rates = supportedRates
        self.userDefaultsManager = userDefaultsManager
    }

    // MARK: - Private Methods

    private func updateView() {
        let lastDateString = "Last update: " + RateDateFormatter.shared.string(from: lastUpdateDate)

        var fromAmount: String {
            guard self.fromAmount != 0 else { return "" }
            
            if floor(self.fromAmount) == self.fromAmount {
                return String(Int(self.fromAmount))
            } else {
                return String(format: "%.2f", self.fromAmount)
            }
        }
        
        var toAmount: String {
            guard
                self.fromAmount != 0,
                let fromRate = ratesResponse?.data[fromRate],
                let toRate = ratesResponse?.data[toRate]
            else {
                return ""
            }

            let convertedAmount = toRate / fromRate * self.fromAmount
            self.toAmount = convertedAmount

            return String(format: "%.2f", convertedAmount)
        }

        DispatchQueue.main.async {
            self.view?.configure(
                with: .init(
                    lastUpdateText: lastDateString,
                    allCurrencies: self.rates,
                    fromRate: self.fromRate,
                    toRate: self.toRate,
                    amount: fromAmount,
                    convertedAmount: toAmount)
            )
        }
    }
}


// MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {

    func viewIsReady() {
        if let savedPair = userDefaultsManager.getLastRatesPair() {
            fromRate = savedPair.0
            toRate = savedPair.1
        }

        updateView()
        interactor?.fetchRates()
    }

    func didTapRateView(with type: RateViewType) {
        router?.showChooseRateAlert(
            output: self,
            rates: rates,
            selectedRate: type == .from ? fromRate : toRate,
            type: type
        )
    }

    func didTapArchiveButton() {
        router?.showArchive()
    }

    func textFieldDidUpdate(string: String?) {
        if let string = string, let amount = Double(string) {
            fromAmount = amount
        } else {
            fromAmount = 0
        }

        updateView()
    }

    func didTapRefresh() {
        interactor?.fetchRates()
    }

    func didTapSwapButton() {
        let tempRate = toRate
        toRate = fromRate
        fromRate = tempRate

        fromAmount = toAmount

        userDefaultsManager.saveLastRatesPair(pair: (fromRate, toRate))

        updateView()
    }

    func didEndEditting() {
        interactor?.saveRecord(fromRate: fromRate, 
                               toRate: toRate,
                               fromAmount: String(format: "%.2f", fromAmount),
                               toAmount: String(format: "%.2f", toAmount))
    }
}


// MARK: - MainInteractorOutput

extension MainPresenter: MainInteractorOutput {

    func didSuccessfullyFetchRates(with response: RatesResponse) {
        ratesResponse = response
        lastUpdateDate = Date()
        updateView()
    }
    
    func didFailureFetchRates(error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

// MARK: - ChooseRateAlertModuleOutput

extension MainPresenter: ChooseRateAlertModuleOutput {
    
    func didSelect(rate: String, selectionType: RateViewType) {
        switch selectionType {
        case .from:
            fromRate = rate
            
        case .to:
            toRate = rate
        }

        userDefaultsManager.saveLastRatesPair(pair: (fromRate, toRate))
        
        updateView()
    }
}
