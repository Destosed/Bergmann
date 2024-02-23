//
//  ArchiveArchivePresenter.swift
//  BergmannTest
//
//  Created by Nikita L on 23/02/2024.
//

import Foundation
import CoreData
import UIKit


protocol ArchiveModuleOutput: AnyObject {

}

protocol ArchiveInteractorOutput: AnyObject {
    func didSuccessfullyFetchRecords(records: [ConversionRecord])
    func didFailureFetchRecords(error: Error)
}

protocol ArchiveViewOutput: ViewOutput {
    func didTapFilterButton()
    func didTapClearButon()
    func didApplyFilter(fromRate: String?, toRate: String?)
}

final class ArchivePresenter {

    // MARK: - Properties

    weak var view: ArchiveViewInput?
    var interactor: ArchiveInteractorInput?
    var router: ArchiveRouterInput?

    // MARK: - Private Properties

    private weak var moduleOutput: ArchiveModuleOutput?
    
    private var records: [ConversionRecord] = []
    private var filteredRecords: [ConversionRecord] = []


    // MARK: - Init
    
    init() {
        
    }
}


// MARK: - ArchiveViewOutput

extension ArchivePresenter: ArchiveViewOutput {
    
    func viewIsReady() {
        interactor?.fetchRecords(fromRate: nil, toRate: nil)
    }

    func didTapFilterButton() {
        view?.showFilterAlert()
    }

    func didTapClearButon() {
        interactor?.deleteRecords()
        records = []
        filteredRecords = []
        view?.update(with: records)
    }

    func didApplyFilter(fromRate: String?, toRate: String?) {
        interactor?.fetchRecords(fromRate: fromRate, toRate: toRate)
    }
}


// MARK: - ArchiveInteractorOutput
extension ArchivePresenter: ArchiveInteractorOutput {

    func didSuccessfullyFetchRecords(records: [ConversionRecord]) {
        view?.update(with: records)
    }
    
    func didFailureFetchRecords(error: Error) {
        // TODO: -
    }
}
