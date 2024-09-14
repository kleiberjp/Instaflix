//
//  DMMediaItem.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import Foundation

enum MediaType: String, Codable {
    case tv
    case movie
    case all
    
    var title: String {
        switch self {
        case .tv:
            return "TV Show"
        case .movie:
            return "Movies"
        default:
            return ""
        }
    }
    
    var headline: String {
        switch self {
        case .tv:
            return "Trending TV Show"
        case .movie:
            return "Trengind Movies"
        default:
            return ""
        }
    }
    
}

struct MediaSection {
    let type: MediaType
    let items: [MediaItem]
}


struct MediaItem: Codable, Hashable {
    var id: Int
    var overview: String
    var title: String?
    var posterPath: String
    var mediaType: MediaType
    
    var posterURL: String {
        return Constants.imageURL + posterPath
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case title
        case posterPath = "poster_path"
        case mediaType = "media_type"
    }
}


extension MediaItem: Equatable {
    static func == (lhs: MediaItem, rhs: MediaItem) -> Bool {
        return lhs.id == rhs.id
    }
}
