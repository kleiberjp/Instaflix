//
//  Network+Error.swift
//  Instaflix
//
//  Created by Kleiber Perez on 11/09/24.
//

import Foundation

enum NetworkError: Error {
    case general
    case timeout
    case pageNotFound
    case noData
    case noNetwork
    case unknownError
    case serverError
    case redirection
    case clientError
    case invalidResponse(httpStatusCode: Int)
    case statusMessage(message: String)
    case decodingError(Error)
    case connectionError(Error)
    case unauthorizedClient
    case urlError(URLError)
    case httpError(HTTPURLResponse)
    case type(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .general:                    return "Bad Request"
        case .timeout:                    return "Timeout"
        case .pageNotFound:               return "No Result"
        case .noData:                     return "No Result"
        case .noNetwork:                  return "Check the Connection"
        case .unknownError:               return "Bad Request"
        case .serverError:                return "Internal Server Error"
        case .redirection:                return "Request doesn't seem to be proper."
        case .clientError:                return "Request doesn't seem to be proper."
        case .invalidResponse:            return "Invalid Server Response"
        case .unauthorizedClient:         return "Unauthorized Client"
        case .statusMessage(let message): return message
        case .decodingError(let error):   return "Decoding Error: \(error.localizedDescription)"
        case .connectionError(let error): return "Network connection Error : \(error.localizedDescription)"
        default: return "Bad Request"
        }
    }
}
