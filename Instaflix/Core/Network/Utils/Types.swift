//
//  Types.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation

public enum HTTPMethod: Equatable {
    case get
    case post
    case put
    case delete
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

public enum URLEncoding: String {
    // Generally for these methods - GET, HEAD, DELETE, CONNECT, OPTIONS
    case `default`
    case percentEncoded
    // Always for POST/PUT METHOD
    case xWWWFormURLEncoded = "application/x-www-form-urlencoded"
}

public enum BodyEncoding: String {
    case JSON
    case xWWWFormURLEncoded = "application/x-www-form-urlencoded"
}


// MARK: Utilities for Encoding items on dictionary objects
extension Dictionary where Key == String, Value == String {
    /// To encode Query parameters as URLEncoded
    func urlEncodedQueryParams() -> String {
        let pairs = reduce([]) { current, keyValPair -> [String] in
            if let encodedVal = "\(keyValPair.value)".addingPercentEncoding(withAllowedCharacters: .nkURLQueryAllowed) {
                return current + ["\(keyValPair.key)=\(encodedVal)"]
            }
            return current
        }
        return pairs.joined(separator: "&")
    }
}

extension Dictionary where Key == String, Value == Any {
    /// To encode request body as URLEncoded
    func urlEncodedBody() throws -> Data {
        var bodyStr = [String]()
        for(key, value) in self {
            bodyStr.append(key + "=\(value)")
        }
        let output = bodyStr.map { String($0) }.joined(separator: "&")
        if let bodyData = output.data(using: .utf8) {
            return bodyData
        } else {
            throw NetworkError.unknownError
        }
    }
}

extension CharacterSet {
    public static let nkURLQueryAllowed: CharacterSet = {
        // https://en.wikipedia.org/wiki/Percent-encoding
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}
