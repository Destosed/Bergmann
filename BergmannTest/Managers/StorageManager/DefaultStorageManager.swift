//
//  DefaultStorageManager.swift
//  BergmannTest
//
//  Created by Никита Лужбин on 23.02.2024.
//

import Foundation
import CoreData

final class DefaultStorageManager {

    // MARK: - Nested Types

    private enum Locals {
        
        static let containerName = "BergmannTest"
        static let entityName = "ConversionRecord"
    }

    // MARK: - Type Properties

    static let shared: StorageManager = DefaultStorageManager()

    // MARK: - Private Properties
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Locals.containerName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Init

    private init() {}

    // MARK: - Private Methods

    private func saveContext() {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - StorageManager

extension DefaultStorageManager: StorageManager {
    
    func createRecord(fromRate:  String, toRate: String, fromAmount: String, toAmount: String) {
        
        let record = ConversionRecord(context: viewContext)
        record.fromRate = fromRate
        record.toRate = toRate
        record.fromAmount = fromAmount
        record.toAmount = toAmount

        saveContext()
    }

    func getRecords(fromRate: String?,
                    toRate: String?,
                    completion: @escaping ((Result<[ConversionRecord], Error>) -> Void)) {

        let fetchRequest = NSFetchRequest<ConversionRecord>(entityName: Locals.entityName)

        var predicates: [NSPredicate] = []

        if let fromRate = fromRate, !fromRate.isEmpty {
            predicates.append(
                .init(
                    format: "%K == %@",
                    #keyPath(ConversionRecord.fromRate),
                    fromRate
                )
            )
        }
        
        if let toRate = toRate, !toRate.isEmpty {
            predicates.append(
                .init(
                    format: "%K == %@",
                    #keyPath(ConversionRecord.toRate),
                    toRate
                )
            )
        }

        if !predicates.isEmpty {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        do {
            let records = try viewContext.fetch(fetchRequest)
            completion(.success(records))
        } catch {
            completion(.failure(error))
        }
    }

    func cleanRecords() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Locals.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        _ = try? viewContext.execute(deleteRequest)
    }
}
