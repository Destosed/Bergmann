//
//  ArchiveArchiveRouter.swift
//  BergmannTest
//
//  Created by Nikita L on 23/02/2024.
//

import Foundation

protocol ArchiveRouterInput {

}

final class ArchiveRouter {


    // MARK: - Properties

    private unowned let transition: TransitionHandler

    
    // MARK: - Init

    init(transition: TransitionHandler) {
        self.transition = transition
    }
}


// MARK: - ArchiveRouterInput
extension ArchiveRouter: ArchiveRouterInput {

}
