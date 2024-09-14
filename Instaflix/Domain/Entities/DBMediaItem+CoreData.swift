//
//  DBMediaItem+CoreData.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import Foundation
import CoreData

extension MediaItemMO: ManagedEntity {}

extension MediaItemMO {
    static func justOneItem() -> NSFetchRequest<MediaItemMO> {
        let request = newFetchRequest()
        request.fetchLimit = 1
        return request
    }
    
    static func items() -> NSFetchRequest<MediaItemMO> {
        let request = newFetchRequest()
        return request
    }
}

extension MediaItem {
    
    @discardableResult
    func save(in context: NSManagedObjectContext) -> MediaItemMO? {
        guard let mediaItem = MediaItemMO.insertNew(in: context) else { return nil }
        
        mediaItem.id = Int64(id)
        mediaItem.title = title
        mediaItem.posterPath = posterPath
        mediaItem.overview = overview
        mediaItem.mediaType = mediaType.rawValue
        
        return mediaItem
    }
    
    init?(managedObject: MediaItemMO) {
        guard let description = managedObject.overview,
              let poster = managedObject.posterPath,
              let media = managedObject.mediaType
        else { return nil }
        
        let mediaType = MediaType(rawValue: media) ?? .movie
        let titleMedia = managedObject.title
        
        self.init(id: Int(managedObject.id), overview: description, title: titleMedia, posterPath: poster, mediaType: mediaType)
    }
}
