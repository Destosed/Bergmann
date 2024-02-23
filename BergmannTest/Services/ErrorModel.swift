//
//  ErrorModel.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 21.02.2024.
//

import Foundation

enum ErrorModel: Error {

    case somethingWentWrong
    case badResponse
    case authWrong
    case noConnection
    case custom(title: String? = nil, message: String? = nil)

    var title: String {
        switch self {
        case .somethingWentWrong: return "SomethingWentWrong"
        case .badResponse: return "Bad Response"
        case .authWrong: return "Auth Wrong"
        case .noConnection: return "No connection"
        case .custom(let title, _): return title ?? ""
        }
    }

    var message: String {
        return "some message"
    }
}
