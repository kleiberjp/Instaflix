//
//  MediaItemDBRepository.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation
import Combine
import CoreData

protocol MediaItemsDBRepositoryProtocol {
    func hasLoadedData() -> AnyPublisher<Bool, Error>
    
    func store(items: [MediaItem]) -> AnyPublisher<Void, Error>
    func getMediaItems() -> AnyPublisher<[MediaItem], Error>
}


struct MediaItemDBRepository: MediaItemsDBRepositoryProtocol {
    
    let dbManager: PersistanceDBManager
    
    init(coreDataManager: PersistanceDBManager = DIContainer.shared.inject(type: PersistanceDBManager.self)!) {
        self.dbManager = coreDataManager
    }
    
    func hasLoadedData() -> AnyPublisher<Bool, any Error> {
        let fetchRequest = MediaItemMO.justOneItem()
        return dbManager
            .count(fetchRequest)
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }
    
    func store(items: [MediaItem]) -> AnyPublisher<Void, any Error> {
        return dbManager
            .insertOrUpdate { context in
                items.forEach {
                    $0.save(in: context)
                }
            }
    }
    
    func getMediaItems() -> AnyPublisher<[MediaItem], any Error> {
        let fetchRequest = MediaItemMO.items()
        return dbManager
            .fetch(fetchRequest) {
                MediaItem(managedObject: $0)
            }
            .eraseToAnyPublisher()
    }
    
    
}
