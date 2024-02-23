//
//  ArchiveArchiveAssembly.swift
//  BergmannTest
//
//  Created by Nikita L on 23/02/2024.
//

import Foundation

final class ArchiveAssembly {
    
    static func assembleModule() -> Module {
        
        let storageManager = DefaultStorageManager.shared
        
        let view = ArchiveViewController()
        let presenter = ArchivePresenter()
        let interactor = ArchiveInteractor(storageManager: storageManager)
        let router = ArchiveRouter(transition: view)
        
        interactor.presenter = presenter
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        view.presenter = presenter
        
        return view
    }
}
