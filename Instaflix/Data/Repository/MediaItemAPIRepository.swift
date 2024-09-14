//
//  MediaItemRemoteRepository.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation
import Combine

protocol MediaItemsAPIRepositoryProtocol: AnyObject {
    func getMediaItem(for section: MediaItemType, of type: MediaType) -> AnyPublisher<[MediaItem], NetworkError>
}

final class MediaItemAPIRepository {
    private let service: MediaItemsRemoteProtocol
    
    init(service: MediaItemsRemoteProtocol = DIContainer.shared.inject(type: MediaItemsRemoteProtocol.self)!) {
        self.service = service
    }
}

extension MediaItemAPIRepository: MediaItemsAPIRepositoryProtocol {
    func getMediaItem(for section: MediaItemType, of type: MediaType) -> AnyPublisher<[MediaItem], NetworkError> {
        return self.service.fetch(section: section, for: type)
    }
}
