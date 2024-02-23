//
//  UserDefaultsManager.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 23.02.2024.
//

import Foundation

protocol UserDefaultsManager {

    func getLastRatesPair() -> (String, String)?
    func saveLastRatesPair(pair: (String, String))
}
