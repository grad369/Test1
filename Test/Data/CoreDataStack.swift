//
//  CoreDataStack.swift
//  Test
//
//  Created by vaskov on 29.04.2025.
//
import CoreData


class CoreDataStack {
    let persistentContainer: NSPersistentContainer

    init(modelName: String = "Test") {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
}
