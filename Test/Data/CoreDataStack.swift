//
//  CoreDataStack.swift
//  Test
//
//  Created by vaskov on 29.04.2025.
//
import CoreData


class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    var mainContext: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    init(modelName: String = "Test") {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
        
    func backgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func save(context: NSManagedObjectContext) async -> Result<Void, Error> {
        await context.perform {
            do {
                if context.hasChanges {
                    try context.save()
                    return .success(())
                }
                return .success(())
            } catch {
                context.rollback()
                return .failure(error)
            }
        }
    }
    
    func deleteAll<T: NSManagedObject>(type: T.Type) async -> Result<Void, Error> {
        let context = backgroundContext()
            
        do {
            try await context.perform {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
            }
            
            return await save(context: context)
        } catch {
            return .failure(error)
        }
    }
}
