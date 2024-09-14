//
//  NetworkClient.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import Foundation
import Combine

typealias BaseAPIProtocol = NetworkClientProtocol

typealias AnyPublisherResult<M> = AnyPublisher<M, NetworkError>

protocol NetworkClientProtocol: AnyObject {

    var session: URLSession { get }

    @discardableResult
    func perform<M: Decodable, T>(with request: RequestBuilder,
                                  decoder: JSONDecoder,
                                  scheduler: T,
                                  responseObject type: M.Type) -> AnyPublisher<M, NetworkError> where M: Decodable, T: Scheduler
}

protocol Logging {
    func logRequest(request: URLRequest)
    func logResponse(response: URLResponse?, data: Data?)
}
