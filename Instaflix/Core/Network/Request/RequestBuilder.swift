//
//  Request.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import Foundation


// MARK: API Interface
protocol NetworkAPI {
    var baseURL: BaseURLType { get }
    var version: VersionType { get }
    var path: String? { get }
    var methodType: HTTPMethod { get }
    var queryParams: [String: String]? { get }
    var queryParamsEncoding: URLEncoding? { get }
    var bodyEncoding: BodyEncoding? { get }
    var parameters: [String: Any]? { get }
    var cachePolicy: URLRequest.CachePolicy? { get }
    var timeoutInterval: TimeInterval? { get }
    var headers: [String: String]? { get }
}

extension NetworkAPI {

    var bodyEncoding: BodyEncoding? {
        return nil
    }

    var parameters: [String: Any]? {
       return nil
    }

    var cachePolicy: URLRequest.CachePolicy? {
        return .useProtocolCachePolicy
    }

    var timeoutInterval: TimeInterval? {
        return 20.0
    }

    var headers: [String: String]? {
        ["Accept": "application/json"]
    }
}

protocol RequestBuilder: NetworkAPI {
    init(request: NetworkAPI)
    var pathAppendedURL: URL { get }
    func setQuery(to urlRequest: inout URLRequest)
    func encodedBody() -> Data?
    func buildURLRequest() -> URLRequest

}

