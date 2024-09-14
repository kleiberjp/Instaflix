//
//  URL+Extensions.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation

extension URL {
    init(_ string: StaticString) {
        self.init(string: "\(string)")!
    }
}

extension HTTPURLResponse {
    var isResponseOK: Bool {
        return (200..<299).contains(statusCode)
    }
}

#if canImport(Combine)
public extension URLRequest {
    var dataTaskPublisher: URLSession.DataTaskPublisher {
        URLSession.shared.dataTaskPublisher(for: self)
    }
}
#endif
