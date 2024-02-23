//
//  ChooseRateAlertChooseRateAlertRouter.swift
//  BergmannTest
//
//  Created by Nikita L on 22/02/2024.
//

import Foundation

protocol ChooseRateAlertRouterInput {
    func close()
}

final class ChooseRateAlertRouter {


    // MARK: - Properties

    private unowned let transition: TransitionHandler

    
    // MARK: - Init

    init(transition: TransitionHandler) {
        self.transition = transition
    }
}


// MARK: - ChooseRateAlertRouterInput

extension ChooseRateAlertRouter: ChooseRateAlertRouterInput {
    
    func close() {
        transition.dismiss(animated: true)
    }
}
