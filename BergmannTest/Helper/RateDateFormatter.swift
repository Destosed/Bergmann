//
//  RateDateFormatter.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 22.02.2024.
//

import Foundation

struct RateDateFormatter {

    // MARK: - Type Properties

    static let shared = RateDateFormatter()

    // MARK: - Instance Ptoperties

    private var outputDateFormater: DateFormatter {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MMM d | HH:mm:ss"
//        dateFormatter.locale = .init(identifier: "ru_RU")

        return dateFormatter
    }

    // MARK: - Init

    private init() { }

    // MARK: - Instance Methods

    func date(from string: String) -> Date? {
        return ISO8601DateFormatter().date(from: string)
    }

    func string(from date: Date) -> String {
        return outputDateFormater.string(from: date)
    }
}
