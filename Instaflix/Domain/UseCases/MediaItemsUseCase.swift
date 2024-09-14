//
//  MediaItemsUsecase.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Combine
import Foundation
import SwiftUI

protocol MediaItemsUseCaseProtocol: AnyObject {
    func getItems(callback: @escaping (_ data: LoadingState<[MediaItem]>) -> Void)
    
}

final class MediaItemsUseCase: MediaItemsUseCaseProtocol {
    
    private let apiRepository: MediaItemsAPIRepositoryProtocol
    private let dbRepository: MediaItemsDBRepositoryProtocol
        
    private let bgQueue = DispatchQueue.global(qos: .userInteractive)
    private let cancelBag = CancelBag()

    init(service: MediaItemsAPIRepositoryProtocol = DIContainer.shared.inject(type: MediaItemsAPIRepositoryProtocol.self)!,
         db: MediaItemsDBRepositoryProtocol = DIContainer.shared.inject(type: MediaItemsDBRepositoryProtocol.self)!) {
        self.apiRepository = service
        self.dbRepository = db
    }
    
    func getItems(callback: @escaping (LoadingState<[MediaItem]>) -> Void) {
        
        Just<Void>.withErrorType(Error.self)
            .flatMap { [dbRepository] _ in
                return dbRepository.hasLoadedData()
            }
            .removeDuplicates()
            .flatMap { [dbRepository] isLoaded in
                return isLoaded ? dbRepository.getMediaItems() : self.loadMediaItemsTrendingFromAPI()
            }
            .removeDuplicates()
            .sinkToLoadable(callback)
            .store(in: cancelBag)
        }
    
    private func loadMediaItemsTrendingFromAPI() -> AnyPublisher<[MediaItem], any Error> {
        return fetchTrendingData()
            .ensureTimeSpan(holdTimeInterval)
            .genericError()
            .flatMap { data -> AnyPublisher<[MediaItem], any Error> in
                return self.saveToDB(data)
            }
            .subscribe(on: bgQueue)
            .receive(on: TaskScheduler.mainThread)
            .eraseToAnyPublisher()
    }
    
    private func fetchTrendingData() -> AnyPublisher<[MediaItem], any Error> {
        let trendTv = apiRepository.getMediaItem(for: .trending, of: .tv)
        let trendMovie = apiRepository.getMediaItem(for: .trending, of: .movie)
        
        
        return Publishers.CombineLatest(trendTv, trendMovie)
            .map {
                $0 + $1
            }
            .genericError()
            .eraseToAnyPublisher()
    }
    
    private func saveToDB(_ data: [MediaItem]) -> AnyPublisher<[MediaItem], Error> {
        return dbRepository.store(items: data)
            .map {
                data
            }
            .genericError()
            .eraseToAnyPublisher()
    }
    
    private var holdTimeInterval: TimeInterval {
        return ProcessInfo.processInfo.isRunningTests ? 0 : 0.25
    }
}
