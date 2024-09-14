//
//  Persistence.swift
//  Instaflix
//
//  Created by Kleiber Perez on 10/09/24.
//

import CoreData
import Combine

protocol PersistanceDBManager {
    typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result
    
    var viewContext: NSManagedObjectContext { get }
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error>
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>,
                     map: @escaping (T) throws -> V?) -> AnyPublisher<[V], Error>
    func insertOrUpdate<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error>
}


struct CoreDataManager: PersistanceDBManager {
   
    private let container: NSPersistentContainer
    private let isDBLoaded = CurrentValueSubject<Bool, Error>(false)
   
    var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "InstaflixDB")
        Task { [weak isDBLoaded, weak container] in
            container?.loadPersistentStores{ ( _, error) in
                guard error.isNull else {
                    isDBLoaded?.send(completion: .failure(error!))
                    return
                }
                
                container?.viewContext.mergePolicy = NSRollbackMergePolicy
                container?.viewContext.automaticallyMergesChangesFromParent = true
                isDBLoaded?.value = true
            }
        }
    }
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, any Error> where T : NSFetchRequestResult {
        return isDBLoaded
            .flatMap { [weak container] _ in
                Future<Int, Error> { promise in
                    do {
                        let count = try container?.viewContext.count(for: fetchRequest) ?? 0
                        promise(.success(count))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>, map: @escaping (T) throws -> V?) -> AnyPublisher<[V], any Error> where T : NSFetchRequestResult {
        assert(Thread.isMainThread)
                
        let fetch = Future<[V], Error> { [weak container] promise in
            guard let context = container?.viewContext else { return }
            context.performAndWait {
                do {
                    let managedObject = try context.fetch(fetchRequest)
                    let results = try managedObject.enumerated().compactMap {
                        let mappedElement = try map($0.element)
                        
                        return mappedElement
                    }
                    
                    promise(.success(results))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        
        return isDBLoaded
            .flatMap { _ in fetch }
            .eraseToAnyPublisher()
    }
    
    
    func insertOrUpdate<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, any Error> {
        let operation = Future<Result, Error> { [weak container] promise in
                guard let context = container?.newBackgroundContext() else { return }
                context.performAndWait {
                    do {
                        let result = try operation(context)
                        if context.hasChanges {
                            try context.save()
                        }
                        context.reset()
                        promise(.success(result))
                    } catch {
                        context.reset()
                        promise(.failure(error))
                    }
                }
        }
        
        return isDBLoaded
            .flatMap { _ in operation }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
