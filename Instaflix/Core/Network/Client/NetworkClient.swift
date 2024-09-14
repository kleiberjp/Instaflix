//
//  NetworkClient.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation
import Combine

final class NetworkClient: NetworkClientProtocol {

    /// Initializes a new URL Session Client.
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    let logging: Logging

    init(logging: Logging = Debugger()) {
        self.logging = logging
    }

    @discardableResult
    func perform<M, T>(with request: RequestBuilder,
                       decoder: JSONDecoder,
                       scheduler: T,
                       responseObject type: M.Type) -> AnyPublisher<M, NetworkError> where M: Decodable, T: Scheduler {
        let urlRequest = request.buildURLRequest()
        self.logging.logRequest(request: urlRequest)
        return publisher(request: urlRequest)
            .tryMap { result, response -> Data in
                self.logging.logResponse(response: response, data: result)
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse(httpStatusCode: 0)
                }
                
                if httpResponse.isResponseOK {
                    return result
                } else {
                    throw NetworkError.invalidResponse(httpStatusCode: httpResponse.statusCode)
                }
            }
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                // Improved error handling and logging
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                }
                return error as? NetworkError ?? .general
            }
            .eraseToAnyPublisher()
    }

    private func publisher(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), NetworkError> {
        return self.session.dataTaskPublisher(for: request)
            .mapError { NetworkError.urlError($0) }
            .eraseToAnyPublisher()
    }
}
