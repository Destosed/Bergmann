//
//  ChooseRateAlertChooseRateAlertPresenter.swift
//  BergmannTest
//
//  Created by Nikita L on 22/02/2024.
//

import Foundation

protocol ChooseRateAlertModuleOutput: AnyObject {
    func didSelect(rate: String, selectionType: RateViewType)
}

protocol ChooseRateAlertInteractorOutput: AnyObject {

}

protocol ChooseRateAlertViewOutput: ViewOutput {
    func onConfirmButtonDidTapped()
    func onCancelButtonDidTapped()
    func didSelect(rate: String)
}

final class ChooseRateAlertPresenter {


    // MARK: - Public Properties

    weak var view: ChooseRateAlertViewInput?
    var interactor: ChooseRateAlertInteractorInput?
    var router: ChooseRateAlertRouterInput?

    // MARK: - Private Properties

    private weak var moduleOutput: ChooseRateAlertModuleOutput?
    private let rates: [String]
    private var selectedRate: String
    private let type: RateViewType

    // MARK: - Init
    
    init(moduleOutput: ChooseRateAlertModuleOutput?,
         rates: [String],
         selectedRate: String,
         rateType: RateViewType) {

        self.moduleOutput = moduleOutput
        self.rates = rates
        self.selectedRate = selectedRate
        self.type = rateType
    }
}


// MARK: - ChooseRateAlertViewOutput
extension ChooseRateAlertPresenter: ChooseRateAlertViewOutput {

    func viewIsReady() {
        view?.configure(rates: rates, selectedRate: selectedRate)
    }

    func onConfirmButtonDidTapped() {
        moduleOutput?.didSelect(rate: selectedRate, selectionType: type)
        router?.close()
    }
    
    func onCancelButtonDidTapped() {
        router?.close()
    }

    func didSelect(rate: String) {
        selectedRate = rate
    }
}


// MARK: - ChooseRateAlertInteractorOutput
extension ChooseRateAlertPresenter: ChooseRateAlertInteractorOutput {
    
}
