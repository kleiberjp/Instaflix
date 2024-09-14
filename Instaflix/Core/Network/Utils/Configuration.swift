//
//  Network+Configuration.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import Foundation

enum BaseURLType {
    case baseApi
    case staging

    var desc: URL {
        switch self {
        case .baseApi:
            return URL("https://api.themoviedb.org")
        case .staging:
            return URL("https://api.themoviedb.org")
        }
    }
}

enum VersionType {
    case none
    case v3
    var desc: String {
        switch self {
        case .none:
            return .empty
        case .v3:
            return "/3"
        }
    }
}
