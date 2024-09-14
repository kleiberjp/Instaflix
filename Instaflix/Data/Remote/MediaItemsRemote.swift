//
//  MediaItemsRemote.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation
import Combine

enum MediaItemType {
    case discover
    case trending
    case upcoming
}

struct MediaResponse: Codable, Hashable {
    let results: [MediaItem]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

protocol MediaItemsRemoteProtocol: AnyObject {
    func fetch(section item: MediaItemType, for type: MediaType) -> AnyPublisher<[MediaItem], NetworkError>
}

final class MediaItemRemote: NetworkClientManager<HttpRequest>, MediaItemsRemoteProtocol {
    func fetch(section item: MediaItemType, for type: MediaType) -> AnyPublisher<[MediaItem], NetworkError> {
        
        let mediaItemRequest = MediaItemRequest(type: type, itemType: item)
        let request = HttpRequest(request: mediaItemRequest)
        
        return self.request(request: request,
                     scheduler: TaskScheduler.mainScheduler,
                            responseObject: MediaResponse.self)
                            .map(\.results)
                            .eraseToAnyPublisher()
    }
    
    
}
struct MediaItemRequest: NetworkAPI {
    
    let type: MediaType
    let itemType: MediaItemType
    
    
    var baseURL: BaseURLType {
        return .baseApi
    }
    
    var version: VersionType {
        return .v3
    }
    
    var path: String? {
        switch (type, itemType) {
        case (.tv, .discover):
            return "/discover/tv"
        case (.tv, .trending):
            return "/trending/tv/day"
        case (.movie, .discover):
            return "/discover/movie"
        case (.movie, .trending):
            return "/trending/movie/day"
        case (.movie, .upcoming):
            return "/movie/upcoming"
        case (.all, .trending):
            return "/trending/all/day"
        default:
            return ""
        }
    }
    
    var methodType: HTTPMethod {
        return .get
    }
    
    var queryParams: [String : String]? {
        var params: [String: String] = ["api_key": Constants.apiKeyTMBD,
                                        "language": Constants.curentLanguage]
        
        switch (type, itemType) {
        case (.tv, .discover), (.movie, .discover):
            params["sort_by"] = "popularity.desc"
        default:
            break
        }
        
        return params
    }
    
    var queryParamsEncoding: URLEncoding? {
        return .default
    }
    
    
}
