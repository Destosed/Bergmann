//
//  MainMainAssembly.swift
//  BergmannTest
//
//  Created by Nikita L on 21/02/2024.
//

import Foundation

final class MainAssembly {

    static func assembleModule() -> Module {
        
        let supportedRates = ["CHF", "CNY", "EUR", "GBP", "RUB", "USD"]
        
        let currencyService: CurrencyService = DefaultCurrencyService.shared
        let storageManager: StorageManager = DefaultStorageManager.shared
        let userDefaultsManager: UserDefaultsManager = DefaultUserDefaultsManager.shared

        let view = MainViewController()
        let presenter = MainPresenter(supportedRates: supportedRates, 
                                      userDefaultsManager: userDefaultsManager)
        let interactor = MainInteractor(currencyService: currencyService,
                                        storageManager: storageManager)
        let router = MainRouter(transition: view)
        
        interactor.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        view.presenter = presenter
        
        return view
    }
}
