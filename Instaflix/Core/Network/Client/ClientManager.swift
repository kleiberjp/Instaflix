//
//  ClientManager.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation
import Combine
import os.log

class NetworkClientManager<Target: RequestBuilder> {

    typealias AnyPublisherResult<M> = AnyPublisher<M, NetworkError>

    // The URLSession client is use to call request with URLSession Data Task Publisher
    private let clientURLSession: NetworkClientProtocol

    public init(clientURLSession: NetworkClientProtocol = NetworkClient()) {
        self.clientURLSession = clientURLSession
    }

    func request<M, T>(request: Target,
                       decoder: JSONDecoder = JSONDecoder(),
                       scheduler: T,
                       responseObject type: M.Type) -> AnyPublisherResult<M> where M: Decodable, T: Scheduler {
        return clientURLSession.perform(with: request, decoder: decoder, scheduler: scheduler, responseObject: type)
    }
}
