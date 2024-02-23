//
//  ChooseRateAlertChooseRateAlertInteractor.swift
//  BergmannTest
//
//  Created by Nikita L on 22/02/2024.
//

import Foundation

protocol ChooseRateAlertInteractorInput: AnyObject {

}

final class ChooseRateAlertInteractor {


    // MARK: - Properties

    weak var presenter: ChooseRateAlertInteractorOutput?


    // MARK: - Init

    init() {
        
    }
}


// MARK: - ChooseRateAlertInteractorInput
extension ChooseRateAlertInteractor: ChooseRateAlertInteractorInput {

}
