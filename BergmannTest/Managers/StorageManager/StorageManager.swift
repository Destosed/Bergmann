//
//  StorageManager.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 23.02.2024.
//

import Foundation

protocol StorageManager {

    func createRecord(fromRate:  String, toRate: String, fromAmount: String, toAmount: String)
    func cleanRecords()
    func getRecords(fromRate: String?,
                    toRate: String?,
                    completion: @escaping ((Result<[ConversionRecord], Error>) -> Void))
}
