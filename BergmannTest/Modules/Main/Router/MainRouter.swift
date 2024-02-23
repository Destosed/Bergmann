//
//  MainMainRouter.swift
//  BergmannTest
//
//  Created by Nikita L on 21/02/2024.
//

import Foundation
import UIKit

protocol MainRouterInput {
    func showArchive()
    func showChooseRateAlert(output: ChooseRateAlertModuleOutput,
                             rates: [String],
                             selectedRate: String,
                             type: RateViewType)
}

final class MainRouter {


    // MARK: - Properties

    private unowned let transition: TransitionHandler

    
    // MARK: - Init

    init(transition: TransitionHandler) {
        self.transition = transition
    }
}


// MARK: - MainRouterInput

extension MainRouter: MainRouterInput {
    
    func showArchive() {
        let vc = ArchiveAssembly.assembleModule()

        transition.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showChooseRateAlert(output: ChooseRateAlertModuleOutput,
                             rates: [String],
                             selectedRate: String,
                             type: RateViewType) {
        let model = ChooseRateAlertAssembly.Model(output: output,
                                                  rates: rates,
                                                  selectedRate: selectedRate,
                                                  type: type)
        let vc = ChooseRateAlertAssembly.assembleModule(with: model)
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        transition.present(vc, animated: true)
    }
}
