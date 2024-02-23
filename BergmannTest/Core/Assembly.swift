//
//  Assembly.swift
//  PokerHelper
//
//  Created by Никита Лужбин on 29.04.2023.
//

import Foundation
import UIKit

typealias Module = UIViewController

protocol Assembly {
    static func assembleModule() -> Module
    static func assembleModule(with model: TransitionModel) -> Module
}

extension Assembly {
    
    static func assembleModule() -> Module {
        fatalError("Implement assembleModule() in ModuleAssembly")
    }
    
    static func assembleModule(with model: TransitionModel) -> Module {
        fatalError("Implement assembleModule(with model: TransitionModel) in ModuleAssembly")
    }
    
}
