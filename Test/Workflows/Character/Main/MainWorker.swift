//
//  MainWorker.swift
//  Test
//
//  Created by vaskov on 30.04.2025.
//
import CoreData


protocol CoreDataWorkerProtocol {
    var dbIsEmpty: Bool { get }
    func save(chars: [CharacterModels.Char]) async -> Result<Void, Error>
    func fetchAllChars() -> Result<[CDCharacter], Error>
    func deleteAllChars() async -> Result<Void, Error>
}

protocol ApiWorkerProtocol {
    func loadNewChars() async -> Result<[CharacterModels.Char], Error>
}

class MainWorker: CoreDataWorkerProtocol, ApiWorkerProtocol {
    private let coreDataStack = CoreDataStack.shared
    private let apiService = ApiService()
    
    // MARK: CoreDataWorkerProtocol -
    var dbIsEmpty: Bool {
        coreDataStack.isEntityEmpty(entityType: CDCharacter.self, context: coreDataStack.mainContext)
    }
    
    func save(chars: [CharacterModels.Char]) async -> Result<Void, Error> {
        let context = coreDataStack.backgroundContext()
        
        let existCharIds = checkExistingChars(ids: chars.map { $0.id })
            .map { Int($0) }
        let noExistChars = chars
            .filter { !existCharIds.contains($0.id) }
        
        for char in noExistChars {
            let cdChar = CDCharacter(context: context)
            cdChar.id = Int64(char.id)
            cdChar.name = char.name
            cdChar.created = char.created
            cdChar.gender = char.gender
            cdChar.image = char.image
            for episode in char.episode ?? [] {
                let cdEpisode = CDEpisode(context: context)
                cdEpisode.episode = episode
                cdChar.addToEpisode(cdEpisode)
            }
        }
        
        return await self.coreDataStack.save(context: context)
    }
    
    func fetchAllChars() -> Result<[CDCharacter], Error> {
        let context = coreDataStack.mainContext
        let fetchRequest: NSFetchRequest<CDCharacter> = CDCharacter.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let chars = try context.fetch(fetchRequest)
            chars.forEach { char in
                char.episode?.forEach { context.refresh($0 as! NSManagedObject, mergeChanges: true) }
            }
            return .success(chars)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteAllChars() async -> Result<Void, Error> {
        await coreDataStack.deleteAll(type: CDCharacter.self)
    }
    
    private func checkExistingChars(ids: [Int]) -> [Int] {
        let context = coreDataStack.mainContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDCharacter.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        
        fetchRequest.returnsObjectsAsFaults = true
        fetchRequest.includesPropertyValues = true
        fetchRequest.propertiesToFetch = ["id"]
        fetchRequest.resultType = .dictionaryResultType
        
        guard let results = try? context.fetch(fetchRequest) as? [[String: Any]] else { return [] }
        let existingIds = results.compactMap { $0["id"] as? Int64 }
        return existingIds.map { Int($0) }
    }
    
    // MARK: ApiWorkerProtocol -
    func loadNewChars() async -> Result<[CharacterModels.Char], Error> {
        do {
            let chars = try await apiService.next(type: CharacterModels.Char.self)
            return .success(chars)
        } catch {
            return .failure(error)
        }
    }
}
