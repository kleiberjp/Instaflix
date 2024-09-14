//
//  MainViewModel.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation
import SwiftUI
import Combine

final class MainViewModel: ObservableObject {
    
    private(set) var categories = [MediaType.movie, MediaType.tv]
    @Published var selectedCategory: MediaType? = nil
    
    var navigateSubject = PassthroughSubject<MainView.MainViewRoutes, Never>()
    
    @Published var sections: [MediaSection] = []
    @Published var filteredMediaItems: [MediaItem] = []
    @Published var isloading: Bool = false
    
    @Published private(set) var mediaItems: LoadingState<[MediaItem]>
    private let mediaItemUseCase: MediaItemsUseCaseProtocol
    
    private let cancelBag = CancelBag()
    
    init(mediaItems: LoadingState<[MediaItem]> = .notRequested,
         mediaItemUseCase: MediaItemsUseCaseProtocol = DIContainer.shared.inject(type: MediaItemsUseCaseProtocol.self)!) {
        self.mediaItems = mediaItems
        self.mediaItemUseCase = mediaItemUseCase
        self.callFirsTime()
    }
}

extension MainViewModel: LifeCycleViewDataFlow {
    
    typealias InputType = MainViewCycle
    
    enum MainViewCycle {
        case onAppear
        case onLoadedData
        case onLoading
    }
    
    func apply(_ input: MainViewCycle) {
        switch input {
        case .onAppear:
            callFirsTime()
        case .onLoading:
            setupLoadingData()
        case .onLoadedData:
            groupSections()
        }
    }
    
    func callFirsTime() {
        guard mediaItems.value.isNullOrEmpty else { return }
        getMediaItems()
    }
    
    func manageState() {
        switch mediaItems {
        case .notRequested, .isLoading(_,_):
            apply(.onLoading)
        case .loaded(_):
            isloading = false
            apply(.onLoadedData)
        default:
            break
        }
    }
    
    func reloadData() {
        getMediaItems()
    }
    
    func filterMediaItems(by type: String?) {
        selectedCategory = MediaType(rawValue: type ?? "")
        
        guard let mediaType = selectedCategory else {
            filteredMediaItems = []
            return
        }
        
        switch mediaType {
        case .movie:
            if let movieMedia = mediaItems.value?.filter({ $0.mediaType == .movie }), !movieMedia.isEmpty {
                filteredMediaItems = movieMedia
            }
        case .tv:
            if let tvMedia = mediaItems.value?.filter({ $0.mediaType == .tv }), !tvMedia.isEmpty {
                filteredMediaItems = tvMedia
            }
        default:
            break
        }
    }
    
    func seeDetail(_ media: MediaItem) {
        navigateSubject.send(.detail(item: media))
    }
    
    private func getMediaItems() {
        mediaItems.setIsLoading(cancelBag: cancelBag)
        mediaItemUseCase.getItems { [weak self] in
            self?.isloading = false
            self?.mediaItems = $0
            self?.apply(.onLoadedData)
        }
    }
    
    private func groupSections() {
        guard sections.isEmpty else { return }
        
        if let movieMedia = mediaItems.value?.filter({ $0.mediaType == .movie }), !movieMedia.isEmpty {
            let movieSection = MediaSection(type: .movie,
                                            items:movieMedia)
            sections.append(movieSection)
        }
        
        if let tvMedia = mediaItems.value?.filter({ $0.mediaType == .tv }), !tvMedia.isEmpty {
            let tvSection = MediaSection(type: .tv,
                                            items:tvMedia)
            sections.append(tvSection)
        }
    }
    
    private func setupLoadingData() {
        isloading = true
    }
}
