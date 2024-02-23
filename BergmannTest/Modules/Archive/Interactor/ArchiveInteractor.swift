//
//  ArchiveArchiveInteractor.swift
//  BergmannTest
//
//  Created by Nikita L on 23/02/2024.
//

import Foundation

protocol ArchiveInteractorInput: AnyObject {
    func fetchRecords(fromRate: String?, toRate: String?)
    func deleteRecords()
}

final class ArchiveInteractor {

    // MARK: - Public Properties

    weak var presenter: ArchiveInteractorOutput?

    // MARK: - Private Properties

    private let storageManager: StorageManager

    // MARK: - Init

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
}


// MARK: - ArchiveInteractorInput

extension ArchiveInteractor: ArchiveInteractorInput {
    
    func fetchRecords(fromRate: String?, toRate: String?) {

        storageManager.getRecords(fromRate: fromRate, toRate: toRate) { [weak self] result in

            switch result {
            case .success(let records):
                self?.presenter?.didSuccessfullyFetchRecords(records: records)

            case .failure(let error):
                self?.presenter?.didFailureFetchRecords(error: error)
            }
        }
    }

    func deleteRecords() {
        storageManager.cleanRecords()
    }
}
