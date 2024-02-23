//
//  DefaultUserDefaultsManager.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 23.02.2024.
//

import Foundation

final class DefaultUserDefaultsManager: UserDefaultsManager {

    // MARK: - Nested Types

    private enum Locals {

        static let fromRate = "fromRate"
        static let toRate = "toRate"
    }

    // MARK: - Type Properties

    static let shared: UserDefaultsManager = DefaultUserDefaultsManager()

    // MARK: - Private Properties

    private let userDefaults = UserDefaults.standard

    // MARK: - Init

    private init() { }

    // MARK: - Public Methods

    func getLastRatesPair() -> (String, String)? {
        if let fromRate = userDefaults.string(forKey: Locals.fromRate),
           let toRate = userDefaults.string(forKey: Locals.toRate) {

            return (fromRate, toRate)
        }

        return nil
    }

    func saveLastRatesPair(pair: (String, String)) {
        userDefaults.setValue(pair.0, forKey: Locals.fromRate)
        userDefaults.setValue(pair.1, forKey: Locals.toRate)
    }
}
