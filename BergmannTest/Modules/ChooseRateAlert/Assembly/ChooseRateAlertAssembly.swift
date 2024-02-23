//
//  ChooseRateAlertChooseRateAlertAssembly.swift
//  BergmannTest
//
//  Created by Nikita L on 22/02/2024.
//

import Foundation

final class ChooseRateAlertAssembly {
    static func assembleModule(with model: TransitionModel) -> Module {
        guard let model = model as? Model else {
            fatalError("Couldn't assemble ChooseRateAlert module")
        }
        
        let view = ChooseRateAlertViewController()
        let presenter = ChooseRateAlertPresenter(moduleOutput: model.output, 
                                                 rates: model.rates,
                                                 selectedRate: model.selectedRate,
                                                 rateType: model.type)
        let interactor = ChooseRateAlertInteractor()
        let router = ChooseRateAlertRouter(transition: view)
        
        interactor.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        view.presenter = presenter
        
        return view
    }
}

extension ChooseRateAlertAssembly {
    struct Model: TransitionModel {        
        let output: ChooseRateAlertModuleOutput?
        let rates: [String]
        let selectedRate: String
        let type: RateViewType
    }
}
